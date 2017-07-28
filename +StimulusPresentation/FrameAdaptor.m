classdef FrameAdaptor < Object.Object  
    methods (Access = public)
        function presentFrame(this, frame, variables)
            frame.present(this,variables);
        end
    end
    
    methods (Access = public)
        function outputSignalHandler=getOutputSignalHandler(this)
            function handler(value, variables)
                this.presentFrame(value, variables);
            end
            outputSignalHandler=@handler;
        end
    end
end