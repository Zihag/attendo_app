# Diff Details

Date : 2024-12-31 02:21:21

Directory d:\\Personal\\Workspace\\Flutter\\attendo_app\\lib

Total : 43 files,  1647 codes, 71 comments, 116 blanks, all 1834 lines

[Summary](results.md) / [Details](details.md) / [Diff Summary](diff.md) / Diff Details

## Files
| filename | language | code | comment | blank | total |
| :--- | :--- | ---: | ---: | ---: | ---: |
| [lib/app_blocs/activity/bloc/activity_bloc.dart](/lib/app_blocs/activity/bloc/activity_bloc.dart) | Dart | 77 | 2 | 8 | 87 |
| [lib/app_blocs/activity/bloc/activity_event.dart](/lib/app_blocs/activity/bloc/activity_event.dart) | Dart | 21 | 0 | 2 | 23 |
| [lib/app_blocs/activity/bloc/activity_state.dart](/lib/app_blocs/activity/bloc/activity_state.dart) | Dart | 1 | 0 | 1 | 2 |
| [lib/app_blocs/activity_choice/bloc/activity_choice_bloc.dart](/lib/app_blocs/activity_choice/bloc/activity_choice_bloc.dart) | Dart | 43 | 0 | 6 | 49 |
| [lib/app_blocs/activity_choice/bloc/activity_choice_event.dart](/lib/app_blocs/activity_choice/bloc/activity_choice_event.dart) | Dart | 11 | 0 | 3 | 14 |
| [lib/app_blocs/activity_choice/bloc/activity_choice_state.dart](/lib/app_blocs/activity_choice/bloc/activity_choice_state.dart) | Dart | 18 | 0 | 7 | 25 |
| [lib/app_blocs/attendance/bloc/attendance_bloc.dart](/lib/app_blocs/attendance/bloc/attendance_bloc.dart) | Dart | -32 | 44 | 1 | 13 |
| [lib/app_blocs/attendance/bloc/attendance_event.dart](/lib/app_blocs/attendance/bloc/attendance_event.dart) | Dart | -20 | 26 | 2 | 8 |
| [lib/app_blocs/attendance/bloc/attendance_state.dart](/lib/app_blocs/attendance/bloc/attendance_state.dart) | Dart | -14 | 19 | 2 | 7 |
| [lib/app_blocs/auth/bloc/auth_bloc.dart](/lib/app_blocs/auth/bloc/auth_bloc.dart) | Dart | 11 | 2 | 8 | 21 |
| [lib/app_blocs/auth/bloc/auth_event.dart](/lib/app_blocs/auth/bloc/auth_event.dart) | Dart | 0 | 0 | 2 | 2 |
| [lib/app_blocs/group/bloc/group_bloc.dart](/lib/app_blocs/group/bloc/group_bloc.dart) | Dart | 1 | 0 | 0 | 1 |
| [lib/app_blocs/invite_member/invitation/bloc/invitation_bloc.dart](/lib/app_blocs/invite_member/invitation/bloc/invitation_bloc.dart) | Dart | 1 | 0 | 0 | 1 |
| [lib/app_blocs/user/bloc/user_state.dart](/lib/app_blocs/user/bloc/user_state.dart) | Dart | 1 | 0 | 0 | 1 |
| [lib/app_colors/app_colors.dart](/lib/app_colors/app_colors.dart) | Dart | 5 | 0 | 1 | 6 |
| [lib/helpers/attendees_bottom_sheet.dart](/lib/helpers/attendees_bottom_sheet.dart) | Dart | 0 | 0 | 1 | 1 |
| [lib/main.dart](/lib/main.dart) | Dart | 8 | 1 | -1 | 8 |
| [lib/screens/activity/create_activity_screen.dart](/lib/screens/activity/create_activity_screen.dart) | Dart | -1 | 0 | 0 | -1 |
| [lib/screens/activity/create_or_update_activity_screen.dart](/lib/screens/activity/create_or_update_activity_screen.dart) | Dart | 185 | 6 | 12 | 203 |
| [lib/screens/authentication/login_screen.dart](/lib/screens/authentication/login_screen.dart) | Dart | -3 | 0 | 0 | -3 |
| [lib/screens/authentication/signup_screen.dart](/lib/screens/authentication/signup_screen.dart) | Dart | 8 | 0 | -1 | 7 |
| [lib/screens/group/group_detail_screen.dart](/lib/screens/group/group_detail_screen.dart) | Dart | 92 | 3 | 3 | 98 |
| [lib/screens/navigation/activity/activity_screen.dart](/lib/screens/navigation/activity/activity_screen.dart) | Dart | 82 | 0 | 2 | 84 |
| [lib/screens/navigation/home/home_screen.dart](/lib/screens/navigation/home/home_screen.dart) | Dart | 197 | 1 | 0 | 198 |
| [lib/screens/navigation/notify/notification_screen.dart](/lib/screens/navigation/notify/notification_screen.dart) | Dart | 16 | 1 | 2 | 19 |
| [lib/screens/navigation/profile/profile_screen.dart](/lib/screens/navigation/profile/profile_screen.dart) | Dart | 213 | 1 | 3 | 217 |
| [lib/screens/navigation/setting/settings_screen.dart](/lib/screens/navigation/setting/settings_screen.dart) | Dart | 162 | 0 | 0 | 162 |
| [lib/services/FCMTokenService.dart](/lib/services/FCMTokenService.dart) | Dart | 45 | 0 | 5 | 50 |
| [lib/services/activity_status_service.dart](/lib/services/activity_status_service.dart) | Dart | 48 | 6 | 12 | 66 |
| [lib/services/attendance_service.dart](/lib/services/attendance_service.dart) | Dart | 43 | 0 | 5 | 48 |
| [lib/services/color_service.dart](/lib/services/color_service.dart) | Dart | 16 | 0 | 1 | 17 |
| [lib/services/convert_service.dart](/lib/services/convert_service.dart) | Dart | 29 | 5 | 11 | 45 |
| [lib/services/invite_user_service.dart](/lib/services/invite_user_service.dart) | Dart | 0 | 1 | 2 | 3 |
| [lib/services/today_activity_service.dart](/lib/services/today_activity_service.dart) | Dart | 26 | 2 | 1 | 29 |
| [lib/widgets/choice_button.dart](/lib/widgets/choice_button.dart) | Dart | 1 | 0 | 0 | 1 |
| [lib/widgets/circle_avatar.dart](/lib/widgets/circle_avatar.dart) | Dart | 11 | 0 | 0 | 11 |
| [lib/widgets/custom_act_listtile.dart](/lib/widgets/custom_act_listtile.dart) | Dart | 0 | -59 | -3 | -62 |
| [lib/widgets/custom_group_listtile.dart](/lib/widgets/custom_group_listtile.dart) | Dart | 24 | 7 | 0 | 31 |
| [lib/widgets/date_time_picker.dart](/lib/widgets/date_time_picker.dart) | Dart | 1 | 0 | 1 | 2 |
| [lib/widgets/group_detail_screen/all_activity_card.dart](/lib/widgets/group_detail_screen/all_activity_card.dart) | Dart | 239 | 3 | 6 | 248 |
| [lib/widgets/group_detail_screen/today_activity_card.dart](/lib/widgets/group_detail_screen/today_activity_card.dart) | Dart | 118 | 0 | 3 | 121 |
| [lib/widgets/setting_screen/setting_container.dart](/lib/widgets/setting_screen/setting_container.dart) | Dart | 50 | 0 | 4 | 54 |
| [lib/widgets/today_activity_listtile.dart](/lib/widgets/today_activity_listtile.dart) | Dart | -87 | 0 | 4 | -83 |

[Summary](results.md) / [Details](details.md) / [Diff Summary](diff.md) / Diff Details