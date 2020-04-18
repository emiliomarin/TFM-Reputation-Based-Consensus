server = 'http://localhost:3000/api/'
add_measure_url = server + 'com.emilio.tfm.add_measure'
setup_agent_url = server + 'com.emilio.tfm.setup_agent'
start_consensus_url = server + 'com.emilio.tfm.start_consensus'
update_subconsensus_id_url = server + 'com.emilio.tfm.update_subconsensus_id'
update_reputation_url = server + 'com.emilio.tfm.update_reputation'

select_system_url = server + 'queries/selectSystem?systemId={}'
select_agent_url = server + 'queries/selectAgent?agentId={}'
select_consensus_system_url = server + 'queries/selectConsensusForSystem?systemId={}'
select_measures_consensus_url = server + 'queries/selectMeasuresForConsensus?consensusId={consensus}&subConsensusId={subConsensus}'




test= server + 'com.emilio.tfm.Agent'
