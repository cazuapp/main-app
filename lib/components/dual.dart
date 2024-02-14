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

class DualResult {
  int? status;
  dynamic base;
  dynamic model;
  dynamic model2;
  dynamic model3;
  dynamic model4;
  dynamic model5;

  DualResult(
      {required this.status,
      this.model,
      this.model2,
      this.model3,
      this.model4,
      this.model5});

  DualResult.initial()
      : this(
            status: 0,
            model: null,
            model2: null,
            model3: null,
            model4: null,
            model5: null);
}
