classdef DisplayAdaptor < StimulusPresentation.FrameAdaptor
    properties (Access = private)
        window
        screenNumber
        backgroundColor
        
        textureCache
    end
    
    methods (Access = private)
        function presentStimuli(this, stimuli, presentationTime)
            if exist('presentationTime', 'var')
                refreshRate=Screen('NominalFrameRate', this.window);
                for i=1:ceil(presentationTime*refreshRate)
                    for j=1:numel(stimuli)
                        this.presentStimulus(stimuli{j});
                    end
                    this.flip();
                end
            else
                for j=1:numel(stimuli)
                    this.presentStimulus(stimuli{j});
                end
                this.flip();
            end
        end
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
        
        function presentCircle(this, circle)
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
        
        function presentCross(this, cross)
            position=cross.getPosition();
            width=cross.getWidth();
            size=cross.getSize();         
            Screen('FillRect', this.window, cross.getColor(),...
                [position(1)-width(1)/2, position(2)-size(2)/2, position(1)+width(1)/2, position(2)+size(2)/2]);
            Screen('FillRect', this.window, cross.getColor(),...
                [position(1)-size(1)/2, position(2)-width(2)/2, position(1)+size(1)/2, position(2)+width(2)/2]);
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
        function this=DisplayAdaptor(screenNumber, backgroundColor, skipTests, gammaTable)
            this.window=[];
            this.screenNumber=screenNumber;
            if exist('skipTests','var') && skipTests
                Screen('Preference', 'SkipSyncTests', 1);
            else
                Screen('Preference', 'SkipSyncTests', 0);
            end
            this.window=Screen('OpenWindow',this.screenNumber, backgroundColor);
            Screen('BlendFunction',this.window,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
            
            if exist('gammaTable','var')
                Screen('LoadNormalizedGammaTable', this.screenNumber, gammaTable*[1 1 1]);
            end
            
            this.backgroundColor=backgroundColor;
            
            this.textureCache=containers.Map();
        end
        
        function close(this)
            Screen('Close', this.window);
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
            if isa(frame, 'Psychtoolbox.TimeCriticalFrame')
                stimuli=frame.getStimuli(variables);
                this.presentStimuli(stimuli, frame.getPresentationTime());
                this.flip();
            elseif isa(frame, 'Psychtoolbox.SequentialFrame')
                frames=frame.getFrames();
                for i=1:numel(frames)-1
                    stimuli=frames{i}.getStimuli(variables);
                    this.presentStimuli(stimuli, frames{i}.getPresentationTime());
                end
                this.presentFrame(frames{end},variables);
            else
                stimuli=frame.getStimuli(variables);
                this.presentStimuli(stimuli);
            end
            
        end
        
        function flip(this)
            Screen('Flip', this.window);
        end
    end
end