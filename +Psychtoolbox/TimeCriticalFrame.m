classdef TimeCriticalFrame < StimulusPresentation.Frame
    properties (Access = private)
        presentationTime
    end
    
    methods (Access = public)
        function this=TimeCriticalFrame(stimulusGenerator, presentationTime)
            this@StimulusPresentation.Frame(stimulusGenerator);
            this.presentationTime=presentationTime;
        end
        
        function presentationTime=getPresentationTime(this)
            presentationTime=this.presentationTime;
        end
    end
end