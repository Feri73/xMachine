classdef InputSignal < Object.Object
    properties (Access = private)
        name
        handler
    end
    
    methods (Access = public)
        function this=InputSignal(name,handler)
            this.name=name;
            this.handler=handler;
        end
        
        function value=run(this, variables)
            value=this.handler(variables);
        end
        
        function name=getName(this)
            name=this.name;
        end
    end
end