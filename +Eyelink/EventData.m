classdef EventData < Utilities.BitEnum
    methods (Access = public)
        function name=getName(this)
            switch this
                case PTBModule.Eyelink.EventData.Gaze
                    name='GAZE';
                case PTBModule.Eyelink.EventData.GazeResolution
                    name='GAZERES';
                case PTBModule.Eyelink.EventData.HeadReferenced
                    name='HREF';
                case PTBModule.Eyelink.EventData.Area
                    name='AREA';
                case PTBModule.Eyelink.EventData.Velocity
                    name='VELOCITY';
                case PTBModule.Eyelink.EventData.FixationAverage
                    name='FIXAVG';
            end
        end
    end
    
    enumeration
        Gaze (1)
        GazeResolution (2)
        HeadReferenced (4)
        Area (8)
        Velocity (16)
        FixationAverage (32)
    end
end