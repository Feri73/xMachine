classdef AudioAdaptor < StimulusPresentation.FrameAdaptor
    properties (Access = private)
        playerCache
    end
    
    methods (Access = protected)
        function player=getPlayer(this, sound)
            if isKey(this.playerCache, sound.getName())
                player=this.playerCache(sound.getName());
            else
                if isempty(sound.getData())
                    [data,frequency]=audioread(sound.getFileAddress());
                    sound.fromVector(data, frequency, sound.getName());
                end
                player=struct('data',sound.getData(),'frequency',sound.getFrequency());
                this.playerCache(sound.getName())=player;
            end
        end

        function presentStimulus(this, sound)
            player=this.getPlayer(sound);
            if strcmp(sound.getType(), 'Sound')
                soundsc(player.data, player.frequency);
            end
        end
    end
    
    methods (Access = public)
        function this=AudioAdaptor()
            this.playerCache=containers.Map();
        end
        
        function presentFrame(this, frame, variables)
            presentFrame@StimulusPresentation.FrameAdaptor(this, frame, variables);
        end
    end
end