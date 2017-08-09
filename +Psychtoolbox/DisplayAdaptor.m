classdef DisplayAdaptor < StimulusPresentation.FrameAdaptor
    properties (Access = private)
        window
        screenNumber
        backgroundColor
        
        textureCache
    end
    
    methods (Access = protected)
        function texture=getTexture(this, image)
            if isKey(this.textureCache, image.getName())
                texture=this.textureCache(image.getName());
            else
                if isempty(image.getData())
                    [data,~,alpha]=imread(image.getFileAddress());
                    if ~isempty(alpha)
                        data(:,:,4)=alpha;
                    end
                    image.fromMatrix(data, image.getName());
                end
                texture=Screen('MakeTexture', this.window, image.getData());
                this.textureCache(image.getName())=texture;
            end
        end
        
        function presentCircle(~, circle)
            rectangle=[circle.getPosition()-circle.getRadius()...
                circle.getPosition()+circle.getRadius()];
            Screen('FrameArc', this.window, circle.getColor() ,rectangle,...
                0, 360, circle.getWidth());
        end
        
        function presentRectangle(this, rectangle)
            rect=[rectangle.getPosition()-rectangle.getSize()/2 ...
                rectangle.getPosition()+rectangle.getSize()/2];
            Screen('FrameRect', this.window, rectangle.getColor(),...
                rect, rectangle.getWidth());
        end
        
        function presentImage(this, image)
            rectangle=[image.getPosition()-image.getSize()/2 ...
                image.getPosition()+image.getSize()/2];
            texture=this.getTexture(image);
            Screen('DrawTexture', this.window, texture, [], rectangle);
        end
        
        function presentTextbox(this, textbox)
            position=textbox.getPosition();
            Screen('DrawText', this.window, textbox.getText(), position(1),position(2),...
                textbox.getColor());
        end
        
        function presentStimulus(this, stimulus)
            this.(['present' stimulus.getType()])(stimulus);
        end
    end
    
    methods (Access = public)
        function this=DisplayAdaptor(screenNumber, backgroundColor)
            this.window=[];
            this.screenNumber=screenNumber;
            this.window=Screen('OpenWindow',this.screenNumber, backgroundColor);
            this.backgroundColor=backgroundColor;
            
            this.textureCache=containers.Map();
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
            presentFrame@StimulusPresentation.FrameAdaptor(this, frame, variables);
            Screen('Flip', this.window);
        end
    end
end