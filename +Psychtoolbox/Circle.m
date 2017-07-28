classdef Circle < StimulusPresentation.Stimulus
    properties (Access = private)
        radius
        position
        color
        width
    end
    
    methods (Access = public)
        function this=Circle(radius, position, color, width)
            this.radius=radius;
            this.position=position;
            this.color=color;
            this.width=width;
        end
        
        function present(this, adaptor)
            rectangle=[this.position-this.radius this.position+this.radius];
            Screen('FrameArc', adaptor.getPTBWindow(), this.color ,rectangle,...
                0, 360, this.width);
        end
    end
end