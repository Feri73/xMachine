classdef StateMachine < Object.Object
    properties (Access = private)
        states
        variables
    end
    
    events
        stateChanged
    end
    
    methods (Access = public)
        function this=StateMachine()
            this.variables=Utilities.VariableSpace();
        end
        
        function addState(this,state)
            this.states{end+1}=state;
        end
        
        function addStateListener(this, handler)
            this.addlistener('stateChanged',handler);
        end
        
        function run(this)
            currentState=this.states{1};
            while true
                currentState.run(this.variables);
                transitions=currentState.getTransitions();
                for i=1:numel(transitions)
                    if transitions{i}.run(this.variables)
                        if currentState ~= transitions{i}.getDestination()
                            this.notify('stateChanged',...
                                StateMachine.StateChangedEvent(currentState.getName(),...
                                    transitions{i}.getDestination().getName()));
                            currentState=transitions{i}.getDestination();
                        end
                        if currentState.isFinal()
                            return;
                        end
                        break;
                    end
                end
            end
        end
    end
end