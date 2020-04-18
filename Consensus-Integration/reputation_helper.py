class AgentsRep:
    def __init__(self, agents_reputation):
        self.agents_reputation = agents_reputation
    
    def get_agent_reputation(self, agent):
        return self.agents_reputation[agent]
    
    def get_agents_reputation(self):
        return self.agents_reputation
    
    def add_reputation(self, agent, reputation):
        if reputation < 0:
            self.agents_reputation[agent].append(0)
        else:
            self.agents_reputation[agent].append(reputation)
