classdef State < Object.Object
    properties (Access = private)
        transitions
        final
        handler
        name
    end
    
    methods (Access = public)
        function this=State(name, handler, final, transitions)
            if ~exist('final','var')
                final=false;
            end
            if ~exist('transitions','var')
                transitions={};
            end
            this.name=name;
            this.handler=handler;
            this.final=final;
            this.transitions=transitions;
        end
        
        function name=getName(this)
            name=this.name;
        end
        
        function res=isFinal(this)
            res=this.final;
        end
        
        function transitions=getTransitions(this)
            transitions=this.transitions;
        end
        
        function addTransition(this,transition)
            this.transitions{end+1}=transition;
        end
        
        function outputSignals=run(this, inputSignals, variables)
            outputSignals=[];
            if nargout(this.handler)>0
                outputSignals=this.handler(inputSignals, variables);
            else
                this.handler(inputSignals, variables);
            end
        end
    end
end