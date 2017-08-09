classdef EventFilter < Utilities.BitEnum
    methods (Access = public)
        function name=getName(this)
            switch this
                case Eyelink.EventFilter.Fixation
                    name='FIXATION';
                case Eyelink.EventFilter.FixationUpdate
                    name='FIXUPDATE';
                case Eyelink.EventFilter.Saccade
                    name='SACCADE';
                case Eyelink.EventFilter.Blink
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