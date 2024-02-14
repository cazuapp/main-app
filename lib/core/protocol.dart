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

class Protocol {
  static const int ok = 1;
  static const int unableToLogIn = 2;
  static const int nointernet = 3;
  static const int noAssoc = 4;
  static const int noExists = 5;

  static const int emailExists = 6;
  static const int tokenProvided = 7;
  static const int unknownError = 8;
  static const int exists = 9;
  static const int operationFailed = 10;
  static const int invalidPassword = 11;
  static const int noFirst = 12;
  static const int noLast = 13;
  static const int noItems = 14;
  static const int unableToAdd = 15;
  static const int noauth = 16;
  static const int expiredToken = 17;
  static const int errToken = 18;
  static const int invalidToken = 19;
  static const int invalidEndpoint = 20;
  static const int invalidHash = 21;
  static const int deleted = 22;
  static const int empty = 24;
  static const int notNumeric = 25;
  static const int missingId = 27;
  static const int noUpdate = 28;
  static const int noFlags = 29;
  static const int updated = 30;
  static const int invalidAgent = 31;
  static const int invalidParam = 32;
  static const int banned = 33;
  static const int badFormat = 36;
  static const int notFound = 37;
  static const int storeClosed = 39;
  static const int rangeTooBig = 40;
  static const int invalidLength = 41;
  static const int noDriver = 42;
  static const int missingStatus = 44;
  static const int missingEmail = 45;
  static const int offline = 46;
  static const int missingValue = 47;
  static const int missingKey = 48;
  static const int noTarget = 49;
  static const int noChange = 50;
  static const int invalidPhone = 51;
  static const int sameParam = 52;
  static const int pendingOrder = 53;
  static const int missmatch = 54;
  static const int noInternet = 56;
  static const int passHasSpaces = 57;

  static const int cantOver = 59;
  static const int busy = 60;
  static const int invalidSecret = 61;
  static const int noOrders = 62;
  static const int flagsProvided = 63;
  static const int noSecret = 64;
  static const int noAdmin = 65;
  static const int orderLimitExceed = 66;
  static const int cancelled = 67;
  static const int ready = 68;
  static const int hasOffspring = 69;
  static const int noKeys = 70;
}
