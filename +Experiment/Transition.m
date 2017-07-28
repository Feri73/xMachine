classdef Transition < Object.Object
    properties (Access = private)
        predicate
        destination
    end
    methods (Access = public)
        function this=Transition(predicate, destination)
            this.predicate=predicate;
            this.destination=destination;
        end
        
        function res=run(this,inputSignals, variables)
            res=this.predicate(inputSignals, variables);
        end
        
        function destination=getDestination(this)
            destination=this.destination;
        end
    end
end