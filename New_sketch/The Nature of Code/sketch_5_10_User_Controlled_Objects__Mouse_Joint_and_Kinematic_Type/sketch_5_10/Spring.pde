// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Class to describe the spring joint (displayed as a line)

class Spring {

  // This is the box2d object we need to create
  MouseJoint mouseJoint;

  Spring() {
    // At first it doesn't exist
    mouseJoint = null;
  }

  //Если он существует, мы устанавливаем его цель в положение мыши.
  void update(float x, float y) {
    if (mouseJoint != null) {
      //Всегда конвертируйте в мировые координаты!
      Vec2 mouseWorld = box2d.coordPixelsToWorld(x,y);
      mouseJoint.setTarget(mouseWorld);
    }
  }

  void display() {
    if (mouseJoint != null) {
      // We can get the two anchor points
      Vec2 v1 = new Vec2(0,0);
      mouseJoint.getAnchorA(v1);
      Vec2 v2 = new Vec2(0,0);
      mouseJoint.getAnchorB(v2);
      // Convert them to screen coordinates
      v1 = box2d.coordWorldToPixels(v1);
      v2 = box2d.coordWorldToPixels(v2);
      // And just draw a line
      stroke(0);
      strokeWeight(1);
      line(v1.x,v1.y,v2.x,v2.y); 
    }
  }


  //Это ключевая функция, где
  //мы прикрепляем пружину к положению x,y
  //и положение объекта Box
  void bind(float x, float y, Box box) {
    // Define the joint
    MouseJointDef md = new MouseJointDef();

    //Тело A — это просто фальшивое наземное тело для простоты (на мыши ничего нет)
    md.bodyA = box2d.getGroundBody();

    //Тело 2 — квадратное, как у коробки.
    md.bodyB = box.body;

    
    // Get the mouse position in world coordinates
    Vec2 mp = box2d.coordPixelsToWorld(x,y);
    // And that's the target
    md.target.set(mp);
    // Some stuff about how strong and bouncy the spring should be
    md.maxForce = 1000.0 * box.body.m_mass;
    md.frequencyHz = 5.0;
    md.dampingRatio = 0.9;

    // Make the joint!
    mouseJoint = (MouseJoint) box2d.world.createJoint(md);
  }

  void destroy() {
    //Мы можем избавиться от сустава, когда мышь отпущена.
    if (mouseJoint != null) {
      box2d.world.destroyJoint(mouseJoint);
      mouseJoint = null;
    }
  }

}


