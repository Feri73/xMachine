classdef EventData < Utilities.BitEnum
    methods (Access = public)
        function name=getName(this)
            switch this
                case Eyelink.EventData.Gaze
                    name='GAZE';
                case Eyelink.EventData.GazeResolution
                    name='GAZERES';
                case Eyelink.EventData.HeadReferenced
                    name='HREF';
                case Eyelink.EventData.Area
                    name='AREA';
                case Eyelink.EventData.Velocity
                    name='VELOCITY';
                case Eyelink.EventData.FixationAverage
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