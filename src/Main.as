/* -*- Mode: java; indent-tabs-mode: nil -*- */
/*
 * Copyright 2013 Mozilla Foundation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
  Air Hockey for Shumway
*/

package {
    import flash.display.*;
    import flash.events.*;
    import flash.ui.*;

    var stageX = 40;
    var stageY = 40;
    var stageWidth = 800;
    var stageHeight = 600;
    public class Main extends Sprite {
        public static var paddle1, paddle2, ball, surface;
        public function Main() {
            stage.frameRate = 60;
            setup();
            addEventListener(Event.ENTER_FRAME, draw);
        }
        private function background(color) {
            var child = new Shape;
            child.graphics.beginFill(color, 0.3);
            child.graphics.drawRect(0, 0, stageWidth, stageHeight);
            stage.addChild(child);
        }
        private function setup() {
            background(0xEEEEEE);
            surface = new Surface(40, 40, stageWidth-80, stageHeight-80);
            ball = new Ball(40, 40, stageWidth-80, stageHeight-80);

            paddle1 = new Paddle(40, 40, stageWidth-80, stageHeight-80, 200, stageHeight / 2);
            paddle2 = new Paddle(40, 40, stageWidth-80, stageHeight-80, stageWidth - 200, stageHeight / 2);
            addChild(surface);
            addChild(ball);
            addChild(paddle1);
            addChild(paddle2);
            addChild((mask = surface.borderMask()));
            paddle1.setup(Keyboard.A, Keyboard.D, Keyboard.W, Keyboard.S);
            paddle2.setup(Keyboard.LEFT, Keyboard.RIGHT, Keyboard.UP, Keyboard.DOWN);
        }
        private function draw(e) {
            ball.draw();
        }
    }
}

import flash.display.*;
import flash.events.*;
import flash.ui.*;

class Ball extends Shape {
    var rangeX, rangeY, rangeWidth, rangeHeight;
    var r;
    var shape;
    function Ball(rangeX, rangeY, rangeWidth, rangeHeight) {
        var child = shape = new Shape;
        this.rangeX = rangeX;
        this.rangeY = rangeY;
        this.rangeWidth = rangeWidth;
        this.rangeHeight = rangeHeight;
        x = rangeX + 20;
        y = rangeY + rangeHeight / 2;
        r = 8;
        graphics.beginFill(0xCC5555, 1);
        graphics.drawCircle(0, 0, r);
    }


    var dx = Math.cos(Math.random() * Math.PI / 2);
    var dy = Math.cos(Math.random() * Math.PI);
    var v = 6;

    function checkWalls() {
        if (x - r <= rangeX) {
            x = rangeX + r;
            dx = -dx;
        } else if (x + r >= rangeX + rangeWidth) {
            x = rangeX + rangeWidth - r;
            dx = -dx;
        }
        if (y - r <= rangeY) {
            y = rangeY + r;
            dy = -dy;
        } else if (y + r >= rangeY + rangeHeight) {
            y = rangeY + rangeHeight - r;
            dy = -dy;
        }
    }
    function checkPaddle(paddle) {
        var ball = this;
        var xr = ball.x - paddle.x;
        var yr = ball.y - paddle.y;
        var dr = Math.sqrt(xr * xr + yr * yr);
        // If radial distance is less than or equal to combined radii of objects
        // then they have collided.
        var dr0 = paddle.r + ball.r;
        if (dr < dr0) {
            var a = Math.atan2(yr, xr);
            var cosa = Math.cos(a);
            var sina = Math.sin(a);

            // rotate position
            var xb = dr0; //xr * cosa + yr * sina;
            var yb = 0; //yr * cosa - xr * sina;

            // rotate direction
            var dxb = dx * cosa + dy * sina;
            var dyb = dy * cosa - dx * sina;

            // bounce
            dxb = -dxb;

            // rotate position back
            var xbf = xb * cosa - yb * sina;
            var ybf = yb * cosa + xb * sina;
            x = paddle.x + xbf;
            y = paddle.y + ybf;

            // rotate direction back
            var dxp = 0;
            var dyp = 0;
            var dxf = dxb * cosa - dyb * sina;
            var dyf = dyb * cosa + dxb * sina;
            dx = dxf;
            dy = dyf;
        }
    }

    function move() {
        // x and y are absolute coordinates
        x = x + v * dx;
        y = y + v * dy;
    }

    function draw() {
        checkWalls();
        checkPaddle(Main.paddle1);
        checkPaddle(Main.paddle2);
        move();
    }
}
class Paddle extends Sprite {
    var rangeX, rangeY, rangeWidth, rangeHeight;
    var r;
    var shape;
    var left, right, up, down;
    function Paddle(rangeX, rangeY, rangeWidth, rangeHeight, x, y) {
        var child = shape = new Shape;
        this.rangeX = rangeX;
        this.rangeY = rangeY;
        this.rangeWidth = rangeWidth;
        this.rangeHeight = rangeHeight;
        this.x = x;
        this.y = y;
        this.r = 25;
        this.x = x;
        this.y = y;
        graphics.beginFill(0x5555FF, 1);
        graphics.drawCircle(0, 0, r);
    }
    function setup(left, right, up, down) {
        stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownEvent);
        this.left = left;
        this.right = right;
        this.up = up;
        this.down = down;
    }
    function move(x, y, r) {
        this.x = x;
        this.y = y;
    }
    function keyDownEvent(myevent) {
        if (myevent.keyCode == this.up) {
            move(x, y - 20, r);
        }
        if (myevent.keyCode == this.down) {
            move(x, y + 20, r);
        }
        if (myevent.keyCode == this.left) {
            move(x - 20, y, r);
        }
        if (myevent.keyCode == this.right) {
            move(x + 20, y, r);
        }
    }
}
class Surface extends Sprite {
    var surfaceX, surfaceY, surfaceWidth, surfaceHeight;
    function Surface(x, y, width, height) {
        surfaceX = x;
        surfaceY = y;
        surfaceWidth = width;
        surfaceHeight = height;
        var child = new Shape;
        child.graphics.beginFill(0xAAFFAA);
        child.graphics.drawRect(x, y, width, height);
        addChild(child);
    }
    function borderMask() {
        var mask = new Shape;
        mask.graphics.beginFill(0x000000, 0);
        mask.graphics.drawRect(surfaceX, surfaceY, surfaceWidth, surfaceHeight);
        return mask;
    }
}
