/*
 * CazuApp - Delivery at convenience.  
 * 
 * Copyright 2023 - Carlos Ferry <cferry@cazuapp.dev>
 *
 * This file is part of CazuApp. CazuApp is licensed under the New BSD License: you can
 * redistribute it and/or modify it under the terms of the BSD License, version 3.
 * This program is distributed in the hope that it will be useful, but without
 * any warranty.
 *
 * You should have received a copy of the New BSD License
 * along with this program. <https://opensource.org/licenses/BSD-3-Clause>
 */

class Httpr {
  static const int ok = 200;
  static const int badRequest = 405;
  static const int invalidToken = 498;
  static const int tokenRequired = 499;
  static const int banned = 600;
  static const int maint = 700;
  static const int internetFailed = 800;
}
