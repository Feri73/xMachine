classdef Experiment < Object.Object
    properties (Access = private)
        inputSignals
        outputSignals
        states
        storages
        parameters
    end
    
    methods (Access = private)
        function resultHandler=convertTransitionHandler(~, transition)
            function res=handler(sharedMemory)
                res=transition.run(sharedMemory.inputSignals,...
                    sharedMemory.variables);
            end
            resultHandler=@handler;
        end
        
        function resultHandler=convertStateHandler(this,state)
            function handler(sharedMemory)
                iSignals=this.inputSignals(state);
                for i=1:numel(iSignals)
                    tmpISignals=sharedMemory.inputSignals;
                    tmpISignals.(iSignals{i}.getName())=...
                        iSignals{i}.run(sharedMemory.variables);
                end
                
                runOutputs=state.run(sharedMemory.inputSignals,...
                    sharedMemory.variables);
                tmpOSignals=sharedMemory.outputSignals;
                oSignals=this.outputSignals(state);
                if oSignals~=Object.Object.Null
                    for i=1:numel(oSignals)
                        tmpOSignals.(oSignals{i}.getName())=...
                            runOutputs.(oSignals{i}.getName());
                        oSignals{i}.run(runOutputs.(oSignals{i}.getName()),...
                            sharedMemory.variables);
                    end
                end
            end
            resultHandler=@handler;
        end
        
    end
    
    methods (Access = public)
        function this=Experiment()
            this.inputSignals=Utilities.ObjectMap();
            this.outputSignals=Utilities.ObjectMap();
            this.states={};
            this.storages={};
            this.parameters={};
        end
        
        function addState(this, state)
            this.states{end+1}=state;
        end
        
        function addStates(this,states)
            for i=1:numel(states)
                this.states{end+1}=states{i};
            end
        end
        
        function addInputSignal(this,states,inputSignal)
            for i=1:numel(states)
                tmp=this.inputSignals(states{i});
                if tmp==Object.Object.Null
                    tmp={};
                end
                tmp{end+1}=inputSignal;
                this.inputSignals(states{i})=tmp;
            end
        end
        
        function addOutputSignal(this,states,outputSignal)
            for i=1:numel(states)
                tmp=this.outputSignals(states{i});
                if tmp==Object.Object.Null
                    tmp={};
                end
                tmp{end+1}=outputSignal;
                this.outputSignals(states{i})=tmp;
            end
        end
        
        function addParameter(this, name)
            this.parameters{end+1}=name;
        end
        
        function addStorage(this, storage)
            this.storages{end+1}=storage;
        end
        
        function stateMachine=compile(this, parameters)
            stateMachine=StateMachine.StateMachine();
            
            statesMap=Utilities.ObjectMap();
            transitionsHandlerMap=Utilities.ObjectMap();
            for i=1:numel(this.states)
                state=StateMachine.State(this.states{i}.getName(),...
                    this.convertStateHandler(this.states{i}),...
                    this.states{i}.isFinal());
                statesMap(this.states{i})=state;
                transitions=this.states{i}.getTransitions();
                for j=1:numel(transitions)
                    transitionsHandlerMap(transitions{j})=...
                        this.convertTransitionHandler(transitions{j});
                end
            end
            
            for i=1:numel(this.states)
                transitions=this.states{i}.getTransitions();
                for j=1:numel(transitions)
                    tmpstate=statesMap(this.states{i});
                    tmpstate.addTransition(StateMachine.Transition(...
                            transitionsHandlerMap(transitions{j}),...
                            statesMap(transitions{j}.getDestination())));
                end
            end
            
            function inputSignalChangedHandler(~, eventData)
                for index=1:numel(this.storages)
                    this.storages{index}.saveInputSignal(eventData.name,...
                        eventData.value);
                end
            end
            
            function outputSignalChangedHandler(~, eventData)
                for index=1:numel(this.storages)
                    this.storages{index}.saveOutputSignal(eventData.name,...
                        eventData.value);
                end
            end
            
            function variableChangedHandler(~, eventData)
                for index=1:numel(this.storages)
                    this.storages{index}.saveVariable(eventData.name,...
                        eventData.value);
                end
            end
            
            function initializeHandler(sharedMemory)
                tmpISignals=Utilities.VariableSpace();
                tmpISignals.addListener(@inputSignalChangedHandler);
                sharedMemory.inputSignals=tmpISignals;
                
                tmpOSignals=Utilities.VariableSpace();
                tmpOSignals.addListener(@outputSignalChangedHandler);
                sharedMemory.outputSignals=tmpOSignals;
                
                tmpVariables=Utilities.VariableSpace();
                tmpVariables.addListener(@variableChangedHandler);
                for index=1:numel(this.parameters)
                    tmpVariables.(this.parameters{index})=parameters.(this.parameters{index});
                end
                sharedMemory.variables=tmpVariables;
            end
            initState=StateMachine.State('__expinit__',@initializeHandler);
            initState.addTransition(StateMachine.Transition(@(sharedMemory)true,statesMap(this.states{1})));
            
            stateMachine.addState(initState);
            for i=1:numel(this.states)
                stateMachine.addState(statesMap(this.states{i}));
            end
            
            function stateChangedHandler(~, eventData)
                for index=1:numel(this.storages)
                    this.storages{index}.saveStateTransition(eventData.sourceName,...
                        eventData.destinationName)
                end
            end
            stateMachine.addStateListener(@stateChangedHandler);
        end
    end
end