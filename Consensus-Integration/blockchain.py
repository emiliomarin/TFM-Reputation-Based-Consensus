import json

import numpy as np
import requests
from consensus import Consensus
from constants import *


class Blockchain:

    def __init__(self, N_agents, agentsMeasures, agents_rep):
        self.N_agents = N_agents
        self.agentsMeasures = agentsMeasures
        self.agents_rep = agents_rep

    @staticmethod
    def pack_data(agentId, systemId, measure, subconsensus_id, consensus_id):
        data = {
            'agentId': agentId,
            'systemId': systemId,
            'measure': measure,
            'subConsensusId': subconsensus_id,
            'consensusId': consensus_id
        }

        return data

    def set_up_agent(self, data,agent_id):
        r = requests.post(setup_agent_url, data=data)
        print(r.content)
        if(r.status_code == 500):
            self.set_up_agent(data,agent_id)
        else:
            print('Agent {} is ready'.format(agent_id))

    def add(self, data, agent_id):
        r = requests.post(add_measure_url, data=data)
        if(r.status_code == 500):
            # MVCC_READ_CONFLICT
            self.add(data,agent_id)
        else:
            rep_response = r.json() # [Agent ID, delta]
            if(rep_response[1] != 0):
                print('Agent {} should update its reputation by {}'. format(
                    agent_id,
                    rep_response[1],
                ))
                # self.update_reputation(rep_response[0],rep_response[1])
            previous_rep = self.agents_rep.get_agent_reputation(agent_id-1)[-1]
            self.agents_rep.add_reputation(agent_id-1, previous_rep + rep_response[1])

            agentMeasure = data['measure']
            print('Agent {} added measure -> {}'.format(agent_id, agentMeasure))
            #self.agentsMeasures[agent_id-1].append(agentMeasure)

    def start_consensus_for_system(self, systemId):
        data = {
            'systemId': systemId
        }
        r = requests.post(start_consensus_url, data=data)
        print(r.content)
        r = requests.get(select_consensus_system_url.format(systemId))
        return r.content[0]

    def update_consensus_for_system(self, systemId, consensus_id, subconsensus_id, in_agents, agents_id):
        # First we get the agents and latest measures
        measures = json.loads(requests.get(select_measures_consensus_url.format(consensus=consensus_id, subConsensus=subconsensus_id)).content)
        measures = sorted(measures,key=lambda m: m['agent'].split('#')[1])
        all_measures = [m['measure'] for m in measures]
        
        new_consensus = Consensus(self.agents_rep)
        # agreed_measures = new_consensus.get_average_consensus(all_measures, in_agents, len(all_measures)+1)
        agreed_measures = new_consensus.get_consensus(all_measures, len(all_measures)+1, in_agents, agents_id) 
        # agreed_measures = new_consensus.get_reputation_consensus(all_measures, len(all_measures)+1, in_agents, agents_id)

        print('Agreed measures for Subconsensus {} should be {}'.format(subconsensus_id, agreed_measures))
        return agreed_measures

    def update_subconsensus_id(self, systemId, consensus_id, subconsensus_id):
        data = {
            'systemId': systemId,
            'subConsensusId': subconsensus_id,
            'consensusId': consensus_id
        }

        r = requests.post(start_consensus_url, data=data)
        print('Update Subconsensus ID to {}: {}'.format(subconsensus_id, r.content[0]))

    def update_reputation(self, agent_id, delta):
        data = {
            'agentId': str(agent_id),
            'delta': delta
        }
        r = requests.post(update_reputation_url, data=data)

        if(r.status_code != 200):
            print(r)
            self.update_reputation(agent_id, delta)
        else:
            if delta < 0:
                print('Agent {} lowered its reputation')
            else:
                print('Agent {} increased its reputation')
