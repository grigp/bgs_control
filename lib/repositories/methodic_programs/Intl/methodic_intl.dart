import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';

/// Возвращает локализованную строуу из оисания методики
/// context - контекст прорисовки,
/// id - идентификатор методики,
/// key - тип фразы
String getMetHeadStr(BuildContext context, int id, String key) {
  if (id == 1) {
    if (key == 'title') {
      return S.of(context).met1_title;
    } else if (key == 'description') {
      return S.of(context).met1_description;
    } else if (key == 'electrods') {
      return S.of(context).met1_electrods;
    } else if (key == 'areases') {
      return S.of(context).met1_areases;
    } else if (key == 'recomendations') {
      return S.of(context).met1_recomendations;
    } else {
      return '';
    }
  } else {
    return '';
  }
}


/// Возвращает локализованную строуу аттрибута методики
/// context - контекст прорисовки,
/// id - идентификатор методики,
/// num - номер атрибута
String getMetAttrStr(BuildContext context, int id, int num) {
  if (id == 1) {
    if (num == 0) {
      return S.of(context).met1_attr0;
    } else {
      return '';
    }
  } else {
    return '';
  }
}

/// Возвращает локализованную строуу этапа методики
/// context - контекст прорисовки,
/// id - идентификатор методики,
/// num - номер этапа
String getMetStageStr(BuildContext context, int id, int num) {
  if (id == 1) {
    if (num == 0) {
      return S.of(context).met1_stage0;
    } else
    if (num == 1) {
      return S.of(context).met1_stage1;
    } else
    if (num == 2) {
      return S.of(context).met1_stage2;
    } else
    if (num == 2) {
      return S.of(context).met1_stage3;
    } else
    {
      return '';
    }
  } else {
    return '';
  }
}