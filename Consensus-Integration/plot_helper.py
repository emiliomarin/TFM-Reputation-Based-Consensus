import plotly
import plotly.plotly as py
import plotly.graph_objs as go
import numpy as np

def plot_nodes(agents_id, connections):
    N_agents = len(agents_id)
    radio = 10
    x = []
    y = []
    angle = 2*np.pi/(N_agents)
    data = []
    annotation = []

    for i in range(0,N_agents):

        x.append(radio*np.cos(angle*i + np.pi/2))
        y.append(radio*np.sin(angle*i + np.pi/2))

    for i in range(0, N_agents):
        agent = go.Scatter(
            x=[x[i]],
            y=[y[i]],
            text=['Agent ' + agents_id[i]],
            mode='markers',
            name = 'Agent ' + agents_id[i],
            marker=dict(size=50))
        data.append(agent)

    for i, in_agents in enumerate(connections):
        for j, agent in enumerate(in_agents):            
            agent_index = agents_id.index(agent)

            from_agent = [x[agent_index], y[agent_index]]
            to_agent = [x[i], y[i]]

            annotation.append(make_arrow(from_agent, to_agent))

    layout = go.Layout(
        showlegend=True,
        annotations=annotation,
    )
    fig = go.Figure(data=data, layout=layout)
    py.plot(fig)
    

def make_arrow(from_agent, to_agent):
    arrow = dict(
        ax=from_agent[0],
        ay=from_agent[1],
        axref='x',
        ayref='y',
        showarrow=True,
        arrowhead=3,
        arrowsize=1,
        arrowwidth=2,
        arrowcolor='#000000',
        x=to_agent[0],
        y=to_agent[1],
        xref='x',
        yref='y',
        standoff = 25
    )
    return arrow

def plot_data(N_agents, measures, subconsensus_id):
    x = [i for i in range(subconsensus_id)]
    data = []
    m = {}
    aux = []
    for agent in range(1,N_agents):
        # if agent in [1]:
        #     continue
        for i in range(0,subconsensus_id):
            aux.append(measures[i][agent-1])
        m[str(agent)] = aux
        aux = []
        trace = go.Scatter(
                    x= x,
                    y= m[str(agent)],
                    name='Agent '+str(agent)
                )
        data.append(trace)

    py.plot(data, filename='test')


def plot_rep(N_agents, agents_rep, subconsensus_id):
    x = [i for i in range(subconsensus_id)]
    data = []
    for agent in range(1,N_agents):
        trace = go.Scatter(
                    x= x,
                    y= agents_rep[agent-1],
                    name='Agent '+str(agent)
                )
        data.append(trace)

    py.plot(data, filename='Reputation')