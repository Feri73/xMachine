classdef Circle < StimulusPresentation.Stimulus
    properties (Access = private)
        radius
        position
        color
        width
    end
    
    methods (Access = public)
        function this=Circle(radius, position, color, width)
            this@StimulusPresentation.Stimulus('Circle');
            this.radius=radius;
            this.position=position;
            this.color=color;
            this.width=width;
        end
        
        function radius=getRadius(this)
            radius=this.radius;
        end
        
        function position=getPosition(this)
            position=this.position;
        end
        
        function color=getColor(this)
            color=this.color;
        end
        
        function width=getWidth(this)
            width=this.width;
        end
    end
end