classdef Frame < Object.Object
    properties (Access = protected)
        stimulusGenerator
    end
    
    methods (Access = public)
        function this=Frame(stimulusGenerator)
            this.stimulusGenerator=stimulusGenerator;
        end
        
        function stimuli=getStimuli(this, variables)
            stimuli=this.stimulusGenerator(variables);
        end
    end
end