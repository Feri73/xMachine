classdef (Abstract) Stimulus < Object.Object
    properties (Access = protected)
        type
    end
    
    methods (Access = public)
        function this=Stimulus(type)
            this.type=type;
        end
        
        function type=getType(this)
            type=this.type;
        end
    end
end