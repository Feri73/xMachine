classdef Adaptor < StimulusPresentation.FrameAdaptor
    properties (Access = private)
        window
        screenNumber
        backgroundColor
    end
    
    methods
        function this=Adaptor(screenNumber, backgroundColor)
            this.window=[];
            this.screenNumber=screenNumber;
            this.window=Screen('OpenWindow',this.screenNumber, backgroundColor);
            this.backgroundColor=backgroundColor;
        end
        
        function window=getPTBWindow(this)
            window=this.window;
        end
        
        function size=getWindowSize(this)
            [width,height]=WindowSize(this.window);
            size=[width,height];
        end
        
        function backgroundColor=getBackgroundColor(this)
            backgroundColor=this.backgroundColor;
        end
        
        function presentFrame(this, frame, variables)
            frame.present(this,variables);
            Screen('Flip', this.window);
        end
    end
end