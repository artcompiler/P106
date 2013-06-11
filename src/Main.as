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
  Pong for Shumway
*/

package {
    import flash.display.*;
    import flash.events.*;
    var stageWidth = 800;
    var stageHeight = 600;
    public class Main extends Sprite {
        public static var paddle, ball, surface;
        public function Main() {
            stage.frameRate = 30;
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
            paddle = new Paddle(40, 40, stageWidth-80, stageHeight-80);
            addChild(surface);
            addChild(ball);
            addChild(paddle);
        }
        private function draw(e) {
            ball.draw();
        }
    }
}

import flash.display.*;
import flash.events.*;

class Ball extends Shape {
    var rangeX, rangeY, rangeWidth, rangeHeight;
    var x0, y0, r0;
    var shape;
    function Ball(rangeX, rangeY, rangeWidth, rangeHeight) {
        var child = shape = new Shape;
        this.rangeX = rangeX;
        this.rangeY = rangeY;
        this.rangeWidth = rangeWidth;
        this.rangeHeight = rangeHeight;
        x0 = rangeX + 20;
        y0 = rangeY + rangeHeight / 2;
        r0 = 5;
        graphics.beginFill(0xCC5555, 1);
        graphics.drawCircle(x0, y0, r0);
    }

    var dx = 3/5, dy = 4/5, v0 = 10;

    function checkWalls() {
        if (x0 - r0 <= rangeX) {
            x0 = rangeX + r0;
            dx = -dx;
        } else if (x0 + r0 >= rangeX + rangeWidth) {
            x0 = rangeX + rangeWidth - r0;
            dx = -dx;
        }
        if (y0 - r0 <= rangeY) {
            y0 = rangeY + r0;
            dy = -dy;
        } else if (y0 + r0 >= rangeY + rangeHeight) {
            y0 = rangeY + rangeHeight - r0;
            dy = -dy;
        }
    }

    function checkPaddle() {
        var ball = this;
        var paddle = Main.paddle;
        var xr = ball.x0 - paddle.x0;
        var yr = ball.y0 - paddle.y0;
        var dr = Math.sqrt(xr * xr + yr * yr);
        // If radial distance is less than or equal to combined radii of objects
        // then they have collided.
        var dr0 = paddle.r0 + ball.r0;
        if (dr < dr0) {
            var a = Math.atan2(yr, xr);
            var cosa = Math.cos(a);
            var sina = Math.sin(a);

            // rotate position
            var xb = 110; //xr * cosa + yr * sina;
            var yb = 0; //yr * cosa - xr * sina;

            // rotate direction
            var dxb = dx * cosa + dy * sina;
            var dyb = dy * cosa - dx * sina;

            // bounce
            dxb = -dxb;

            // rotate position back
            var xbf = xb * cosa - yb * sina;
            var ybf = yb * cosa + xb * sina;
            x0 = paddle.x0 + xbf;
            y0 = paddle.y0 + ybf;

            // rotate direction back
            var dxp = 0;
            var dyp = 0;
            var dxf = dxb * cosa - dyb * sina;
            var dyf = dyb * cosa + dxb * sina;
            dx = dxf;
            dy = dyf;

            paddle.draw();
        }
    }

    function move() {
        // x and y are absolute coordinates
        x0 = x0 + v0 * dx;
        y0 = y0 + v0 * dy;
        graphics.beginFill(0xCC5555);
        graphics.drawCircle(x0, y0, r0);
    }

    function draw() {
        //trace("draw() x0=" + x0 + " y0=" + y0 + " r0=" + r0 + " rangeX=" + rangeX + " rangeY=" + rangeY);
        graphics.beginFill(0xAAFFAA);
        graphics.drawCircle(x0, y0, r0);
        checkWalls();
        checkPaddle();
        move();
    }
}

class Paddle extends Sprite {
    var rangeX, rangeY, rangeWidth, rangeHeight;
    var x0, y0, r0;
    var shape;
    function Paddle(rangeX, rangeY, rangeWidth, rangeHeight) {
        var child = shape = new Shape;
        this.rangeX = rangeX;
        this.rangeY = rangeY;
        this.rangeWidth = rangeWidth;
        this.rangeHeight = rangeHeight;
        x0 = rangeX + rangeWidth / 2;
        y0 = rangeY + rangeHeight / 2;
        r0 = 100;
        graphics.beginFill(0x5555FF, 1);
        graphics.drawCircle(x0, y0, r0);
    }
    function move(x, y, r) {
        // x and y are absolute coordinates
        graphics.beginFill(0xAAFFAA);
        graphics.drawCircle(x0, y0, r0);        
        graphics.beginFill(0x5555FF);
        graphics.drawCircle(x, y, r);
        x0 = x, y0 = y;
    }
    function draw() {
        graphics.beginFill(0x5555FF, 1);
        graphics.drawCircle(x0, y0, r0);
    }
}

class Surface extends Sprite {
    var surfaceX, surfaceY, surfaceWidth, surfaceHeight;
    function Surface(x, y, width, height) {
        var child = new Shape;
        child.graphics.beginFill(0xAAFFAA);
        child.graphics.drawRect(x, y, width, height);
        addChild(child);
    }
}
