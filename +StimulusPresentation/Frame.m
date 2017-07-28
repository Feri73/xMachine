classdef Frame < Object.Object
    properties (Access = protected)
        stimulusGenerator
    end
    
    methods (Access = public)
        function this=Frame(stimulusGenerator)
            this.stimulusGenerator=stimulusGenerator;
        end
        function present(this, adaptor, variables)
            stimuli=this.stimulusGenerator(variables);
            for i=1:numel(stimuli)
                stimuli{i}.present(adaptor);
            end
        end
    end
end