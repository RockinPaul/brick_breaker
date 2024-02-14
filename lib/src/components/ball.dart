import 'package:brick_breaker/src/brick_breaker.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../brick_breaker.dart';
import 'play_area.dart';

class Ball extends CircleComponent
    with CollisionCallbacks, HasGameReference<BrickBreaker> {
  Ball(
      {required this.velocity, required super.position, required double radius})
      : super(
          radius: radius,
          anchor: Anchor.center,
          paint: Paint()
            ..color = const Color(0xff1e6091)
            ..style = PaintingStyle.fill,
          children: [CircleHitbox()],
        );

  final Vector2 velocity;

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
  }

  // Flame's collision callbacks have a life cycle. The callbacks are onCollisionStart,
  // onCollision, and onCollisionEnd. The initial version of this game was written in
  // terms of onCollision and required additional code to handle follow-on collision
  // callbacks on later game ticks. Using the right callback for the right purpose
  // significantly simplifies your code!
  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is PlayArea) {
      if (intersectionPoints.first.y <= 0) {
        velocity.y = -velocity.y;
      } else if (intersectionPoints.first.x <= 0) {
        velocity.x = -velocity.x;
      } else if (intersectionPoints.first.x >= game.width) {
        velocity.x = -velocity.x;
      } else if (intersectionPoints.first.y >= game.height) {
        removeFromParent();
      }
    } else {
      debugPrint('collision with $other');
    }
  }
}
