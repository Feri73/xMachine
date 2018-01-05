classdef Mouse < Object.Object
    properties (Access = private)
        deviceAddress
    end
    
    methods (Access = public)
        function state=getState(~)
            state=struct();
            [x,y,state.buttons]=GetMouse();
            state.position=[x,y];
        end
        
        function handler=getInputSignalHandler(this)
            handler=@signalHandler;
            function value=signalHandler(~)
                value=this.getState();
            end
        end
    end
end