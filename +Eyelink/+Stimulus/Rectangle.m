classdef Rectangle < StimulusPresentation.Stimulus
    properties (Access = private)
        size
        position
        color
        filled
    end
    
    methods (Access = public)
        function this=Rectangle(size, position, color, filled)
            this.size=size;
            this.position=position;
            this.color=color;
            this.filled=filled;
        end
        
        function present(this, adaptor)
            rectangle=[this.position-this.size/2 this.position+this.size/2];
            if this.filled
                command='draw_filled_box';
            else
                command='draw_box';
            end
            Eyelink('command', '%s %d %d %d %d %d', command, rectangle, ...
                adaptor.convertColor(this.color));
        end
    end
end