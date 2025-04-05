mkdir -p models services screens/auth screens/home screens/users widgets utils && \
touch main.dart \
models/user.dart models/token.dart models/auth_request.dart \
services/api_service.dart services/auth_service.dart services/user_service.dart \
screens/auth/login_screen.dart screens/auth/register_screen.dart \
screens/home/home_screen.dart screens/home/user_list_screen.dart \
screens/users/create_user_screen.dart screens/users/edit_user_screen.dart screens/users/user_detail_screen.dart \
screens/splash_screen.dart \
widgets/user_card.dart widgets/custom_textfield.dart widgets/role_dropdown.dart \
utils/constants.dart utils/helpers.dart
