'use strict';

/**
 * Create Measure for Agent
 * @param {com.emilio.tfm.add_measure} transaction
 * @transaction
 */
async function add_measure(transaction) {
    const factory = getFactory();
    const namespace = 'com.emilio.tfm';

    const agentId = transaction.agentId;
    const systemId = transaction.systemId;
    const measure = transaction.measure;
    const subConsensusId = transaction.subConsensusId;
    const consensusId = transaction.consensusId;
    var newMeasure;

    // const measuresQuery = await query('selectMeasures');
    const consensusQuery = await query('selectConsensusForSystem', {'systemId': systemId});

    //newMeasure = factory.newResource(namespace, 'Measure', (measuresQuery.length+1).toString());
    let formattedId = `${agentId}-${consensusId}-${subConsensusId}`
    newMeasure = factory.newResource(namespace, 'Measure', formattedId);

    newMeasure.agent = factory.newRelationship(namespace, 'Agent', agentId);
    newMeasure.systemId = systemId;
    newMeasure.consensusId = consensusId;
    newMeasure.subConsensusId = parseInt(subConsensusId)
    newMeasure.measure = measure;

    const measuresRegistry = await getAssetRegistry(namespace + '.Measure');
    await measuresRegistry.add(newMeasure);

    const agentRegistry = await getParticipantRegistry(namespace + '.Agent');

    // Check if the agent exist, if not create it
    const agentQuery = await query('selectAgent',{'agentId':agentId});

    if(agentQuery.length < 1){
        throw new Error('Agent not registered');
    }else{
        let agent = agentQuery[0];
        agent.measure.measure = measure;

        await agentRegistry.update(agent)
    }

    // Check if new subconsensusId
    if(consensusQuery[0].subConsensusId != subConsensusId){
        const consensusRegistry = await getAssetRegistry(namespace + '.Consensus');
        consensusQuery[0].subConsensusId = parseInt(subConsensusId);
        await consensusRegistry.update(consensusQuery[0]);
    }

    // Verification
    // if(subConsensusId != 0){
    //     response = verify_measure(agentId, measure, consensusId, subConsensusId);
    //     return response
    // }
    return [0,0]
}

async function verify_measure(agentId, measure, consensusId, subConsensusId){
    const weight_max = 0.2;
    const maxRep = 100;
    const agentQuery = await query('selectAgent', {'agentId': agentId});
    const inAgents = agentQuery[0]['inAgents'];
    const previousMeasures = await query('selectMeasuresForConsensus', {'consensusId': consensusId, 'subConsensusId': subConsensusId-1});

    const agentPrevMeasureDict = previousMeasures.filter(function(m){
        return m.agent.getIdentifier() == agentId;
    });

    const inAgentsPrevMeasures = previousMeasures.filter(function(m){
        var aux = []
        for (let index = 0; index < inAgents.length; index++) {
            aux.push(inAgents[index].getIdentifier())
            
        }
        return aux.includes(m.agent.getIdentifier());
    });

    const agentPrevMeasure = agentPrevMeasureDict[0].measure;
    var agentMeasure = agentPrevMeasure;
    var inAgentRep = 100
    var updatedWeight = 0
    console.log("Verify Measure for Agent " + agentId + " in round "+ subConsensusId)
    console.log(" ==> In Agents:")
    console.log(inAgents)
    for (let i = 0; i < inAgents.length; i++) {
        inAgentRep = await query('selectAgent',{'agentId':inAgents[i].getIdentifier().toString()});
        inAgentRep = inAgentRep[0]["reputation"]
        console.log(" ==> Reputation for inAgent:")
        console.log("Agent: "+inAgents[i].getIdentifier().toString())
        console.log("Rep: "+inAgentRep)
        console.log("Measure: "+inAgentsPrevMeasures[i].measure)
        updatedWeight = weight_max*inAgentRep/maxRep;
        agentMeasure += updatedWeight*(inAgentsPrevMeasures[i].measure - agentPrevMeasure);
    }
    console.log(" ==> Measure for agent: " + agentId +  " should be: " + agentMeasure + " and it is: " + measure)
    const error = Math.abs(agentMeasure-measure)/measure;

    const agentIdInt = parseInt(agentId)
    if(error > 0.025){
        // Lower reputation
        await update_reputation({
            'agentId': agentId,
            'delta': -30
        })
        return [agentIdInt, -30]
    }else{
        //await change_reputation(agentId, 30);
        await update_reputation({
            'agentId': agentId,
            'delta': 5
        })
        if(agentQuery[0].reputation > 95){
            return [agentIdInt, 0]
        }else{
            return [agentIdInt, 5]
        }
    }
}

/**
 * Update Subconsensus ID
 * @param {com.emilio.tfm.update_subconsensus_id} transaction
 * @transaction
 */
async function update_subconsensus_id(transaction) {
    const factory = getFactory();
    const namespace = 'com.emilio.tfm';

    const systemId = transaction.systemId;
    const subConsensusId = transaction.subConsensusId
    const consensusId = transaction.consensusId

    const consensusQuery = await query('selectConsensusForSystem', {'systemId': systemId});
    const consensusRegistry = await getAssetRegistry(namespace + '.Consensus');
    consensusQuery[0].subConsensusId = parseInt(subConsensusId);
    await consensusRegistry.update(consensusQuery[0]);
    
}

// TODO: OUTDATED, HAVE TO INCLUDE INAGENTS
/**
 * Update reputation for Agent
 * @param {com.emilio.tfm.setup_agent} transaction
 * @transaction
 */
async function setup_agent(transaction) {
    const factory = getFactory();
    const namespace = 'com.emilio.tfm';

    const agentId = transaction.agentId;
    const systemId = transaction.systemId;
    const consensusId = transaction.consensusId;
    const measure = transaction.measure;
    let newMeasure;

    // Check if the system exists
    const systemsRegistry = await getAssetRegistry(namespace + '.System');
    var systemQuery = await query('selectSystem', {'systemId':systemId});

    if(systemQuery.length < 1){
        const createSystem = await register_system({'systemId':systemId});
    }

    const agentRegistry = await getParticipantRegistry(namespace + '.Agent');

    // Check if the agent exist, if not create it
    const agentQuery = await query('selectAgent',{'agentId':agentId});
    
    if(agentQuery.length < 1){
        const agent = factory.newResource(namespace, 'Agent', agentId);
        const currentMeasure = factory.newConcept(namespace, 'CurrentMeasure');
        currentMeasure.measure = measure;

        agent.measure = currentMeasure;
        agent.reputation = 100;
        await agentRegistry.add(agent);

    }

    // Associate agent to system
    systemQuery = await query('selectSystem', {'systemId':systemId}); // Get the newly created system
    const formattedAgent = 'resource:com.emilio.tfm.Agent#'+agentId
    if(!systemQuery[0].agents.includes(formattedAgent)){
        // Agent hasn't joined the system
        const relationship = factory.newRelationship(namespace, 'Agent', agentId);
        systemQuery[0].agents.push(relationship);
        await systemsRegistry.update(systemQuery[0]);
    }
    
}


/**
 * Update reputation for Agent
 * @param {com.emilio.tfm.update_reputation} transaction
 * @transaction
 */
async function update_reputation(transaction) {
    const factory = getFactory();
    const namespace = 'com.emilio.tfm';
    const agentId = transaction.agentId;
    const delta = transaction.delta;
    const agentRegistry = await getParticipantRegistry(namespace + '.Agent');
    var  agentsQuery = await query('selectAgent', {'agentId': agentId});
    var agent = agentsQuery[0];

    if(agent.reputation + delta > 100){
        agent.reputation = 100;
    }else if(agent.reputation + delta < 0){
        agent.reputation = 0;
    }else{
        agent.reputation = agent.reputation + delta;
    }

    await agentRegistry.update(agent);
    agentsQuery = await query('selectAgent', {'agentId': agentId});
}

/**
 * Register new system
 * @param {com.emilio.tfm.register_system} transaction
 * @transaction
 */
async function register_system(transaction) {
    const factory = getFactory();
    const namespace = 'com.emilio.tfm';

    const systemId = transaction.systemId;

    const systemsRegistry = await getAssetRegistry(namespace + '.System');

    const systemQuery = await query('selectSystem', {'systemId':systemId});

    if(systemQuery.length < 1){
        const system = factory.newResource(namespace, 'System', systemId);
        system.agents = []
        await systemsRegistry.add(system)
    }else{
        throw new Error('This system is already registered');
    }

}

/**
 * @param {com.emilio.tfm.start_consensus} transaction
 * @transaction
 */
async function start_consensus(transaction) {
    let factory = getFactory();
    const namespace = 'com.emilio.tfm';

    const systemId = transaction.systemId;
    const consensusRegistry = await getAssetRegistry(namespace + '.Consensus');

    const previousConsensus = await query('selectConsensusForSystem', {'systemId': systemId})
    if(previousConsensus.length > 0){
        const prev = previousConsensus[0]
        prev.status = 'INACTIVE'
        await consensusRegistry.update(prev)
    }

    const consensusQuery = await query('selectAllConsensus');
    let consensusId = (consensusQuery.length + 1).toString()

    const consensus = factory.newResource(namespace, 'Consensus', consensusId);
    consensus.systemId = systemId
    consensus.subConsensusId = 0
    consensus.status = 'PENDING'
    consensus.agreedMeasure = 0.0

    await consensusRegistry.add(consensus)
}

/**
 * @param {com.emilio.tfm.update_consensus} transaction
 * @transaction
 */
async function update_consensus(transaction) {
    let factory = getFactory();
    const namespace = 'com.emilio.tfm';

    const systemId = transaction.systemId;
    const measure = transaction.measure;

    const consensusRegistry = await getAssetRegistry(namespace + '.Consensus');

    const consensusQuery = await query('selectConsensusForSystem', {'systemId': systemId});
    const consensus = consensusQuery[0];

    consensus.agreedMeasure = measure;
    consensus.subConsensusId = consensus.subConsensusId + 1;


    await consensusRegistry.update(consensus);

}

/**
 * @param {com.emilio.tfm.BasicEventTransaction} transaction
 * @transaction
 */
async function basicEventTransaction(transaction) {
    let factory = getFactory();
    const systemId = transaction.systemId;
    const consensusId = transaction.consensusId;

    let consensusEvent = factory.newEvent('com.emilio.tfm', 'StartConsensus');
    consensusEvent.systemId = systemId;
    consensusEvent.consensusId = consensusId;
    emit(consensusEvent);
}