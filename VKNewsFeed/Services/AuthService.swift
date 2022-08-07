//
//  AuthService.swift
//  VKNewsFeed
//
//  Created by Andriy on 19.07.2022.
//

import VKSdkFramework

//Створимо протокол через який будемо делегувати в SceneDelegate
protocol AuthServiceDelegate: AnyObject {
    //Метод буде передавати контроллер рейстрації або входу в vk
    func authServiceShouldShow(_ viewController: UIViewController)
    //Коли користувач все зарейструваввся або увійшов
    func authServiceSignIn()
    //Помилка
    func authServiceDidSignInFail()
}

//Клас відповідає за авторизацію користувача final - клас фінальний, тобто без наслідування та переоприділення
final class AuthService: NSObject, VKSdkDelegate, VKSdkUIDelegate {
    
    static var shared = AuthService()

    //id програми, беремо з сайту вк
    private let appId = "6869574"
    //Будемо використовувати як точку входу
    private let vkSdk: VKSdk
    
    //Делегат який передамо в SceneDelegate та там обробимо його
    weak var delegate: AuthServiceDelegate?
    
    //Отримаємо токен користувача
    var token: String? {
        return VKSdk.accessToken().accessToken
    }
    
    //Отримаємо userId для отримання данних про користувача
    var userId: String? {
        return VKSdk.accessToken().userId
    }
    
    override init() {
        //Ініціалізуємо через id програми
        vkSdk = VKSdk.initialize(withAppId: appId)
        super.init()
        print("VKSdk.initialize")
        //Призначем делегата
        vkSdk.register(self)
        vkSdk.uiDelegate = self
    }
    
    //Метод який перевірить чи користувач авторизований чи хоче це зробити
    func wakeUpSession() {
        //Список прав доступу
        let scope = ["wall", "friends"]
        
        //Витягуємо токін та перевіряємо чи дозволено програмі використовувати токін доступа користувача. [delegate] - створює копію для того щоб при зміні його в іншому місті в замиканні він немінявся
        VKSdk.wakeUpSession(scope) { [delegate] state, error in
            //Юзер авторизований
            if state == VKAuthorizationState.authorized {
                print("VKAuthorizationState.authorized")
                delegate?.authServiceSignIn()
            } else if state == VKAuthorizationState.initialized {  //Програма готова до ініціалізації - тут будемо авторизовувати користувача
                print("VKAuthorizationState.initialized")
                //Метод який авторизовує користувача по списку прав
                VKSdk.authorize(scope)
                
            } else {
                print("auth problem, state \(state) error \(String(describing: error))")
                delegate?.authServiceDidSignInFail()
            }
            
        }
    }
    
    // MARK: VKSdkDelegate
    
    //Метод повідомляє про те що авторизація завершена
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        //Буде виводити назву функції
        print(#function)
        //Якщо буде токен то підемо далі
        if result.token != nil {
        self.delegate?.authServiceSignIn()
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        print(#function)
    }
    
    // MARK: VKSdkUIDelegate
    
    //Цей метод спрацьовує тоді коли користувач хоче авторизуватись - він має свій контролерр для рейстрації
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print(#function)
        //Передаємо контроллер рейстрації в мотод протокола
        self.delegate?.authServiceShouldShow(controller)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(#function)
    }
    
}
