classdef EventFilter < Utilities.BitEnum
    methods (Access = public)
        function name=getName(this)
            switch this
                case PTBModule.Eyelink.EventFilter.Fixation
                    name='FIXATION';
                case PTBModule.Eyelink.EventFilter.FixationUpdate
                    name='FIXUPDATE';
                case PTBModule.Eyelink.EventFilter.Saccade
                    name='SACCADE';
                case PTBModule.Eyelink.EventFilter.Blink
                    name='BLINK';
            end
        end
    end
    
    enumeration
        Fixation (1)
        FixationUpdate (2)
        Saccade (4)
        Blink (8)
    end
end