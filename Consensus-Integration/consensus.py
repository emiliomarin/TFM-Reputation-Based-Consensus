import copy
import numpy as np

class Consensus:
    def __init__(self, agents_rep):
        self.agents_rep = agents_rep

    def get_average_consensus(self, measures, in_agents, N_agents):
        xk1 = []
        for i in range(1,N_agents):
            avg = np.average([measures[int(k)-1] for k in in_agents[i-1]])
            m = measures[i-1]
            error = m-avg

            xk1.append(m-error/2)

        return xk1

    def get_consensus(self, measures, N_agents, in_agents, agents_id):
        xk = measures
        a = 0.25
        xk1 = copy.deepcopy(xk)

        for i, val_i in enumerate(agents_id):
            for j, val_j in enumerate(agents_id):
                if (val_i != val_j) and (val_j in in_agents[i]):
                    xk1[i] += a*(xk[j] - xk[i])

        return xk1

    def get_reputation_consensus(self, measures, N_agents, in_agents, agents_id):
        xk = measures
        max_weight = 0.2
        max_rep = 100
        xk1 = copy.deepcopy(xk)

        for i, val_i in enumerate(agents_id):
            for j, val_j in enumerate(agents_id):
                if (val_i != val_j) and (val_j in in_agents[i]):
                    rep = self.agents_rep.get_agent_reputation(j)[-1]
                    xk1[i] += (max_weight*rep/max_rep)*(xk[j] - xk[i])

        return xk1
