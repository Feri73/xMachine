classdef SampleData < Utilities.BitEnum
    methods (Access = public)
        function name=getName(this)
            switch this
                case PTBModule.Eyelink.SampleData.Gaze
                    name='GAZE';
                case PTBModule.Eyelink.SampleData.GazeResolution
                    name='GAZERES';
                case PTBModule.Eyelink.SampleData.HeadReferenced
                    name='HREF';
                case PTBModule.Eyelink.SampleData.Area
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