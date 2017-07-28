classdef Eyelink1000Plus < StimulusPresentation.FrameAdaptor
    properties (Access = private)
        params
        config
        colors
    end
    
    methods (Access = private)
        function text=createConfigText(~, recordedEyeBit, configBit, enumerations)
            text='';
            if PTBModule.Eyelink.RecordedEye.Left.isIn(recordedEyeBit)
                text=[text ',LEFT'];
            end
            if PTBModule.Eyelink.RecordedEye.Right.isIn(recordedEyeBit)
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
    end
    
    methods (Access = public)
        function this=Eyelink1000Plus(ptbAdaptor, config)
            this.params=EyelinkInitDefaults(ptbAdaptor.getPTBWindow());
            
            this.params.backgroundcolour=ptbAdaptor.getBackgroundColor();
            this.params.msgfontcolour=ptbAdaptor.getBackgroundColor();
            this.params.calibrationtargetcolour=...
                this.negativeColor(ptbAdaptor.getBackgroundColor());
            
            this.params.calibrationtargetsize=config.calibrationTargetSize;
            this.params.calibrationtargetwidth=config.calibrationTargetWidth;
            
            EyelinkUpdateDefaults(this.params);
            
            EyelinkInit(0);
            
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
                    enumeration('PTBModule.Eyelink.EventFilter')));
            Eyelink('command', 'file_event_data = %s',...
                this.createConfigText(config.recordedEye,config.fileEventData,...
                    enumeration('PTBModule.Eyelink.EventData')));
            Eyelink('command', 'file_sample_data = %s',...
                this.createConfigText(config.recordedEye,config.fileSampleData,...
                    enumeration('PTBModule.Eyelink.SampleData')));
            Eyelink('command', 'link_event_filter = %s',...
                this.createConfigText(config.recordedEye,config.linkEventFilter,...
                    enumeration('PTBModule.Eyelink.EventFilter')));
            Eyelink('command', 'link_event_data = %s',...
                this.createConfigText(config.recordedEye,config.linkEventData,...
                    enumeration('PTBModule.Eyelink.EventData')));
            Eyelink('command', 'link_sample_data = %s',...
                this.createConfigText(config.recordedEye,config.linkSampleData,...
                    enumeration('PTBModule.Eyelink.SampleData')));
            
            Eyelink('command', 'fixation_update_interval = %d', config.fixationUpdateInterval);
            Eyelink('command', 'fixation_update_accumulate = %d', config.fixationUpdateAccumulate);
            
            this.colors=[0 0 0; 0 51 204; 51 204 51; 0 153 153; 255 51 0;...
                255 51 204; 179 179 0; 178 177 174; 158 157 154; 170 128 255;...
                102 255 102; 153 255 255; 255 128 128; 255 128 191; 255 255 128;...
                226 223 215];
            
            this.config=config;
        end
        
        function calibrate(this)
            EyelinkDoTrackerSetup(this.params);
        end
        
        function start(this)
            Eyelink('Openfile', this.config.dataFileName);
            Eyelink('StartRecording',1,1,1,1);
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
            Eyelink('message', text);
        end
        
        function dataMap=getNextEvent(this, iterations)
            dataMap=Utilities.ObjectMap();
            for i=1:iterations
                eType=Eyelink('GetNextDataType');
                event=[];
                switch eType
                    case this.params.STARTBLINK
                        event=PTBModule.Eyelink.EventType.StartBlink;
                    case this.params.ENDBLINK
                        event=PTBModule.Eyelink.EventType.EndBlink;
                    case this.params.STARTSACC
                        event=PTBModule.Eyelink.EventType.StartSaccade;
                    case this.params.ENDSACC
                        event=PTBModule.Eyelink.EventType.EndSaccade;
                    case this.params.STARTFIX
                        event=PTBModule.Eyelink.EventType.StartFixation;
                    case this.params.ENDFIX
                        event=PTBModule.Eyelink.EventType.EndFixation;
                    case this.params.FIXUPDATE
                        event=PTBModule.Eyelink.EventType.FixationUpdate;
                end
                if ~isempty(event)
                    dataMap(event)=Eyelink('getfloatdata', eType);
                end
            end
        end
        
        function inputSignalHandler=getInputSignalHandler(this, iterations)
            function value=handler(~)
                value=this.getNextEvent(iterations);
            end
            inputSignalHandler=@handler;
        end
        
        function color=convertColor(this, rgb)
            [~,color]=min(sum((this.colors-rgb).^2,2));
            color=color-1;
        end
        
        function presentFrame(this, frame, variables)
            Eyelink('command', 'clear_screen %d',...
                this.convertColor(this.backgroundColor));
            frame.present(this,variables);
        end
    end
end