import json
import random
import threading

import numpy as np
import requests
from blockchain import Blockchain
from consensus import Consensus
from constants import *
from plot_helper import *
from reputation_helper import AgentsRep
import copy

def generate_measures(block, subconsensus_id, agreed_m, consensus_id, agreed_m_prev, agents_rep):
    threads = list()

    for i in range(1, N_agents):
        
        agent_measure = agreed_m[i-1]

        # if i==1:
        #     if (subconsensus_id+1)%2 == 0:
        #         agent_measure = 15
        #     else:
        #         agent_measure = 5

        if subconsensus_id >= 2 and subconsensus_id < 15 and i==1:
            agent_measure = agreed_m_prev[0]


        print('i = {} || agentmeasure = {}'.format(i, agent_measure))
        data = block.pack_data(i,'001', agent_measure, subconsensus_id, consensus_id)
        x = threading.Thread(target=block.add, args=(data,i))
        threads.append(x)
        x.start()

    for _, thread in enumerate(threads):
        thread.join()
    

def get_relationships(system_id):
    global agents_id
    # Get agents relationships
    relationships = []

    r_system = json.loads(requests.get(select_system_url.format(system_id)).content)

    sorted_agents = sorted(r_system[0]['agents'], key=lambda agent: agent.split('#')[1])
    agents_in_system = [id.split('#')[1] for id in sorted_agents]

    agents_id = agents_in_system

    for agent in agents_in_system:
        r_agent = json.loads(requests.get(select_agent_url.format(agent)).content)
        agent_rel = [rel.split('#')[1] for rel in r_agent[0]['inAgents']]
        relationships.append(agent_rel)

    return relationships

def find_max_difference(a, reps):
    measures_with_rep = copy.deepcopy(a)
    for i, rep in enumerate(reps):
        if rep[-1] == 0:
            # Agents with no reputation should not affect the consensus
            measures_with_rep.pop(i)

    return max(measures_with_rep) - min(measures_with_rep)

# TODO: Only allow agent to add measures when a consensus is set to pending
if __name__ == "__main__":
    global agentsMeasures
    global agreedMeasures
    global N_agents 
    global flag
    global agents_id # MUST BE SORTED FROM LOWER TO GREATER
    global agents_rep

    # Setup plotly
    plotly.tools.set_credentials_file(username='marinemilio', api_key='3aFxAh5l9t5vVxlaiTxL')

    # Initialize values
    N_agents = 8 # Number of agents + 1
    N_measures = 60 # Number of measures
    agentsMeasures = []
    agreedMeasures = []
    system_id = '001'
    agreed_m = []
    agreed_m_prev = []
    agents_rep = AgentsRep([[100], [100], [100], [100], [100], [100], [100]])

    # Setup new blockchain object
    block = Blockchain(N_agents, agentsMeasures, agents_rep)
    
    # Get agents relationships
    in_agents = get_relationships(system_id)

    # Make agents graph
    # plot_nodes(agents_id, in_agents)

    # Start a new consensus
    consensusData = block.start_consensus_for_system(system_id)
    consensus = requests.get(select_consensus_system_url.format(system_id)).content
    consensus_id = json.loads(consensus)[0]['consensusId']
    subconsensus_id = 0

    # Initialize first measure
    # first_measure = [i for i in range(1,N_agents)]
    first_measure = [5, 15, 5, 15, 5, 15, 5]

    agentsMeasures.append(first_measure)

    flag = True
    while (flag and subconsensus_id < N_measures):
        print()
        print('-'*20)
        generate_measures(block, subconsensus_id, agentsMeasures[subconsensus_id], consensus_id, agreed_m_prev, agents_rep)

        agreed_m_prev = agreed_m
        agreed_m = block.update_consensus_for_system(system_id, consensus_id, subconsensus_id, in_agents, agents_id)
        
        # if((subconsensus_id+1)%2 == 0):
        #     agreed_m[0] = 15
        # else:
        #     agreed_m[0] = 5

        if subconsensus_id >=2 and subconsensus_id < 15:
            agreed_m[0] = agreed_m_prev[0]

        agentsMeasures.append(agreed_m)
        subconsensus_id += 1

        max_diff = find_max_difference(agreed_m, block.agents_rep.get_agents_reputation())
        if max_diff < 0.01:
            print('Consensus Reached!')
            break
        else:
            print('Consensus Not Reached, max difference = {}'.format(max_diff))

    plot_data(N_agents, agentsMeasures, subconsensus_id)
    # plot_rep(N_agents, block.agents_rep.get_agents_reputation(), subconsensus_id)


