
import plotly.plotly as py
import plotly.graph_objs as go

trace1 = go.Scatter(
x=[0, 0, 10, 10],
y=[0, 10, 0, 10],
text=['...'],
mode='markers',
name = 'Agents',
marker=dict(size=[100, 100, 100, 100]))


layout = go.Layout(
showlegend=True,
annotations=[
    dict(
        ax=0,
        ay=0,
        axref='x',
        ayref='y',
        showarrow=True,
        arrowhead=3,
        arrowsize=1,
        arrowwidth=2,
        arrowcolor='#000000',
        x=0,
        y=10,
        xref='x',
        yref='y',
        standoff = 0
    ),
    dict(
        ax=0,
        ay=10,
        axref='x',
        ayref='y',
        showarrow=True,
        arrowhead=3,
        arrowsize=1,
        arrowwidth=2,
        arrowcolor='#000000',
        x=0,
        y=0,
        xref='x',
        yref='y',
        standoff = 0
    ),
])

data = [trace1]
fig = go.Figure(data=data, layout=layout)
py.plot(fig)
