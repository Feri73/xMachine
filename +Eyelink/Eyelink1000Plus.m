classdef Eyelink1000Plus < StimulusPresentation.FrameAdaptor
    properties (Access = private)
        params
        config
        colors
        ptbAdaptor
        
        dummyMode
    end

    methods (Access = private)
        function text=createConfigText(~, recordedEyeBit, configBit, enumerations)
            text='';
            if Eyelink.RecordedEye.Left.isIn(recordedEyeBit)
                text=[text ',LEFT'];
            end
            if Eyelink.RecordedEye.Right.isIn(recordedEyeBit)
                text=[text ',RIGHT'];
            end
            for i=1:numel(enumerations)
                if enumerations(i).isIn(configBit)
                    text=[text ',' enumerations(i).getName()];
                end
            end
            text=text(2:end);
        end
        
        function negColor=negativeColor(~, color)
            negColor=255*(color<(255/2));
        end
        
        function color=convertColor(this, rgb)
            if size(rgb,2)>3
                rgb=rgb(1:3);
            end
            [~,color]=min(sum((this.colors-rgb).^2,2));
            color=color-1;
        end
        
        function presentCircle(this, circle)
            this.presentRectangle(StimulusPresentation.VisualStimulus.Rectangle(...
                repmat(circle.getRadius(),2,1), circle.getPosition(),...
                circle.getColor(), circle.getWidth()));
        end
        
        function presentRectangle(this, rectangle)
            size=rectangle.getSize();
            width=rectangle.getWidth();
            position=rectangle.getPosition();
            rect=[position-size/2 position+size/2];
            if (size(1)-2*width)*(size(2)-2*width) < size(1)*size(2)/2 
                command='draw_filled_box';
            else
                command='draw_box';
            end
            Eyelink('command', sprintf('%s %f %f %f %f %d', command, rect, ...
                this.convertColor(rectangle.getColor())));
        end
        
        function presentImage(~, image)
            position=image.getPosition();
            size=image.getSize();
            imwrite(image.getData(), [image.getName() 'tmp.bmp']);
            Eyelink('ImageTransfer', [image.getName() 'tmp.bmp'],...
                position(1), position(2), size(1), size(2));
        end
        
        function presentCross(this, cross)
            Eyelink('command', sprintf('draw_cross %f %f %d', cross.getPosition(),...
                this.convertColor(cross.getColor())));
        end
        
        function presentTextbox(this, textbox)
            Eyelink('command', sprintf('draw_text %f %f %d %s', textbox.getPosition(), ...
                this.convertColor(textbox.getColor()), textbox.getText()));
        end
        
        function res=valueToString(this, value, maxLength)
            if isnumeric(value) || islogical(value)
                res=mat2str(value);
            elseif ischar(value)
                res=['''' value ''''];
            elseif iscell(value)
                res='{';
                for v=value
                    res=[res ',' this.valueToString(v{1})];
                end
                res=[res '}'];
            elseif isa(value,'containers.Map')
                res=['containers.Map(' this.valueToString(keys(value)) ','...
                    this.valueToString(values(value)) ')'];
            else
                res='<not supported>';
            end
            
            if exist('maxLength','var') && numel(res)>maxLength
                res='<too long>';
            end
        end
    end
    
    methods (Access = protected)
        function presentStimulus(this, stimulus)
            this.(['present' stimulus.getType()])(stimulus);
        end
    end

    methods (Access = public)
        function this=Eyelink1000Plus(ptbAdaptor, config, dummyMode)
            this.params=EyelinkInitDefaults(ptbAdaptor.getPTBWindow());

            this.params.backgroundcolour=ptbAdaptor.getBackgroundColor();
            this.params.msgfontcolour=ptbAdaptor.getBackgroundColor();
            this.params.calibrationtargetcolour=...
                this.negativeColor(ptbAdaptor.getBackgroundColor());

            this.params.calibrationtargetsize=config.calibrationTargetSize;
            this.params.calibrationtargetwidth=config.calibrationTargetWidth;
            
            Eyelink('SetAddress',config.ip);

            EyelinkUpdateDefaults(this.params);
            
            if ~exist('dummyMode','var')
                dummyMode=0;
            end

            EyelinkInit(dummyMode);

            windowSize=ptbAdaptor.getWindowSize();
            Eyelink('command','screen_pixel_coords = %ld %ld %ld %ld',...
                0, 0, windowSize(1)-1, windowSize(2)-1);
            Eyelink('message', 'DISPLAY_COORDS %ld %ld %ld %ld',...
                0, 0, windowSize(1)-1, windowSize(2)-1);

            Eyelink('command','calibration_type = %s', config.calibrationType.name);
            Eyelink('command','generate_default_targets = YES');

            Eyelink('command','select_parser_configuration = %ld',...
                double(config.parserConfiguration));

            Eyelink('command', 'file_event_filter = %s',...
                this.createConfigText(config.recordedEye,config.fileEventFilter,...
                    enumeration('Eyelink.EventFilter')));
            Eyelink('command', 'file_event_data = %s',...
                this.createConfigText(0,config.fileEventData,...
                    enumeration('Eyelink.EventData')));
            Eyelink('command', 'file_sample_data = %s',...
                this.createConfigText(config.recordedEye,config.fileSampleData,...
                    enumeration('Eyelink.SampleData')));
            Eyelink('command', 'link_event_filter = %s',...
                this.createConfigText(config.recordedEye,config.linkEventFilter,...
                    enumeration('Eyelink.EventFilter')));
            Eyelink('command', 'link_event_data = %s',...
                this.createConfigText(0,config.linkEventData,...
                    enumeration('Eyelink.EventData')));
            Eyelink('command', 'link_sample_data = %s',...
                this.createConfigText(config.recordedEye,config.linkSampleData,...
                    enumeration('Eyelink.SampleData')));

            Eyelink('command', 'fixation_update_interval = %d', config.fixationUpdateInterval);
            Eyelink('command', 'fixation_update_accumulate = %d', config.fixationUpdateAccumulate);

            this.colors=[0 0 0; 0 51 204; 51 204 51; 0 153 153; 255 51 0;...
                255 51 204; 179 179 0; 178 177 174; 158 157 154; 170 128 255;...
                102 255 102; 153 255 255; 255 128 128; 255 128 191; 255 255 128;...
                226 223 215];

            this.config=config;
            this.ptbAdaptor=ptbAdaptor;
            this.dummyMode=dummyMode;
        end
        
        function calibrate(this)
            EyelinkDoTrackerSetup(this.params);
        end

        function start(this)
            Eyelink('Openfile', this.config.dataFileName);
            Eyelink('StartRecording',1,1,(this.config.linkSampleData~=0)*1,1);
        end

        function startTrial(~, id, message)
            Eyelink('message', 'TRIALID %d', id);
            Eyelink('command', 'record_status_message "%s"', message);
        end

        function endTrial(~, resultCode)
            Eyelink('message', ['TRIAL_RESULT ' num2str(resultCode)]);
            Eyelink('message', 'TRIAL OK');
        end

        function stop(~)
            Eyelink('StopRecording');
            Eyelink('CloseFile');
            Eyelink('ReceiveFile');
            Eyelink('Shutdown');
        end

        function tag(~, text)
            Eyelink('message', replace(text,'%',' '));
        end

        function dataMap=getNextEvent(this, iterations)
            dataMap=Utilities.ObjectMap();
            
            if this.dummyMode
                mousePos=get(0, 'PointerLocation');
                size=get(0,'ScreenSize');
                mousePos(2)=size(4)-mousePos(2);
                dataMap(Eyelink.EventType.StartSaccade)=struct('gstx',mousePos(1),'gsty',mousePos(2));
                dataMap(Eyelink.EventType.EndSaccade)=struct('genx',mousePos(1),'geny',mousePos(2));
                dataMap(Eyelink.EventType.StartFixation)=struct('gstx',mousePos(1),'gsty',mousePos(2));
                dataMap(Eyelink.EventType.EndFixation)=struct('genx',mousePos(1),'geny',mousePos(2));
                dataMap(Eyelink.EventType.FixationUpdate)=struct('gavx',mousePos(1),'gavy',mousePos(2));
                dataMap(Eyelink.EventType.Sample)=struct('gx',[mousePos(1) mousePos(1)],...
                    'gy',[mousePos(2) mousePos(2)]);
            else
                for i=1:iterations
                    eType=Eyelink('GetNextDataType');
                    event=[];
                    switch eType
                        case this.params.STARTBLINK
                            event=Eyelink.EventType.StartBlink;
                        case this.params.ENDBLINK
                            event=Eyelink.EventType.EndBlink;
                        case this.params.STARTSACC
                            event=Eyelink.EventType.StartSaccade;
                        case this.params.ENDSACC
                            event=Eyelink.EventType.EndSaccade;
                        case this.params.STARTFIX
                            event=Eyelink.EventType.StartFixation;
                        case this.params.ENDFIX
                            event=Eyelink.EventType.EndFixation;
                        case this.params.FIXUPDATE
                            event=Eyelink.EventType.FixationUpdate;
                        case this.params.SAMPLE_TYPE
                            event=Eyelink.EventType.Sample;
                    end
                    if ~isempty(event)
                        dataMap(event)=Eyelink('getfloatdata', eType);
                    end
                end
            end
        end

        function inputSignalHandler=getInputSignalHandler(this, iterations)
            function value=handler(~)
                value=this.getNextEvent(iterations);
            end
            inputSignalHandler=@handler;
        end
        
        function [saveDataHandler, saveStateHandler]=getStorageHandlers(this)
            function saveDataH(name, value)
                this.tag([name ': ' this.valueToString(value, 241-numel(name))]);
            end
            
            function saveStateH(sourceName, destinationName)
                this.tag([sourceName '=>' destinationName]);
            end
            
            saveDataHandler=@saveDataH;
            saveStateHandler=@saveStateH;
        end

        function presentFrame(this, frame, variables)
            Eyelink('command', 'clear_screen %d',...
                this.convertColor(this.ptbAdaptor.getBackgroundColor()));
            presentFrame@StimulusPresentation.FrameAdaptor(this, frame, variables);
        end
    end
end
