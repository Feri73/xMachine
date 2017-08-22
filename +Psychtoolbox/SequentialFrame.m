classdef SequentialFrame < StimulusPresentation.Frame
    properties (Access = private)
        frames
    end
    
    methods (Access = public)
        function this=SequentialFrame(frames)
            this@StimulusPresentation.Frame(frames{end}.stimulusGenerator);
            this.frames=frames;
        end
        
        function frames=getFrames(this)
            frames=this.frames;
        end
    end
end