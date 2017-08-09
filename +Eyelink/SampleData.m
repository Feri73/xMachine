classdef SampleData < Utilities.BitEnum
    methods (Access = public)
        function name=getName(this)
            switch this
                case Eyelink.SampleData.Gaze
                    name='GAZE';
                case Eyelink.SampleData.GazeResolution
                    name='GAZERES';
                case Eyelink.SampleData.HeadReferenced
                    name='HREF';
                case Eyelink.SampleData.Area
                    name='AREA';
            end
        end
    end
    enumeration
        Gaze (1)
        GazeResolution (2)
        HeadReferenced (4)
        Area (8)
    end
end