classdef OutputSignal < Object.Object
    properties (Access = private)
        name
        handler
    end
    
    methods (Access = public)
        function this=OutputSignal(name,handler)
            this.name=name;
            this.handler=handler;
        end

        function run(this, value, variables)
            this.handler(value, variables);
        end

        function name=getName(this)
            name=this.name;
        end
    end
end