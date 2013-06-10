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
        r0 = 10;
        graphics.beginFill(0xCC5555, 1);
        graphics.drawCircle(x0, y0, r0);
    }
    function move(x, y, r) {
        // x and y are absolute coordinates
        graphics.beginFill(0xAAFFAA);
        graphics.drawCircle(x0, y0, r0);        
        graphics.beginFill(0xCC5555);
        graphics.drawCircle(x, y, r);
        x0 = x, y0 = y;
    }
    var dx = 1, dy = 0, v0 = 10;
    function draw() {
        //trace("draw() x0=" + x0 + " y0=" + y0 + " r0=" + r0 + " rangeX=" + rangeX + " rangeY=" + rangeY);
        if (x0 - r0 <= rangeX ||
            x0 + r0 >= rangeX + rangeWidth) {
            dx = -dx;
        }
        if (y0 - r0 <= rangeY ||
            y0 + r0 >= rangeY + rangeHeight) {
            dy = -dy;
        }
        // Compute the radial distance between objects.
        var ball = this;
        var paddle = Main.paddle;
        var rx = ball.x0 - paddle.x0;
        var ry = ball.y0 - paddle.y0;
        var rd = Math.sqrt(rx * rx + ry * ry);
        // If radial distance is less than or equal to combined radii of objects
        // then the have collided.
        var rd0 = paddle.r0 + ball.r0;
        if (rd <= rd0) {
            trace("PONG rd0=" + rd0 + " rd=" + rd);
            var rx0 = rx / rd;
            var ry0 = ry / rd;
            trace("PONG rx0=" + rx0 + " ry0=" + ry0 + " dx=" + dx + " dy=" + dy);
            dx = dx + rx;
            dy = dy + ry;
            trace("PONG rx0=" + rx0 + " ry0=" + ry0 + " dx=" + dx + " dy=" + dy);
        }
        move(x0 + v0 * dx, y0 + v0 * dy, r0);
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
    var dx = 1, dy = .5, v0 = 10;
    function draw() {
        //trace("draw() x0=" + x0 + " y0=" + y0 + " r0=" + r0 + " rangeX=" + rangeX + " rangeY=" + rangeY);
        if (x0 - r0 <= rangeX ||
            x0 + r0 >= rangeX + rangeWidth) {
            dx = -dx;
        }
        if (y0 - r0 <= rangeY ||
            y0 + r0 >= rangeY + rangeHeight) {
            dy = -dy;
        }
        move(x0 + v0 * dx, y0 + v0 * dy, r0);        
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
