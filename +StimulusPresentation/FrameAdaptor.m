classdef (Abstract) FrameAdaptor < Object.Object  
    methods (Access = protected, Abstract)
        presentStimulus(this, stimulus);
    end
    
    methods (Access = public)
        function presentFrame(this, frame, variables)
            stimuli=frame.getStimuli(variables);
            for i=1:numel(stimuli)
                this.presentStimulus(stimuli{i});
            end
        end
        
        function outputSignalHandler=getOutputSignalHandler(this)
            function handler(value, variables)
                this.presentFrame(value, variables);
            end
            outputSignalHandler=@handler;
        end
    end
end