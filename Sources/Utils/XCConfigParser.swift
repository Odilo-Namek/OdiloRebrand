//
//  XcConfigProperties.swift
//  OdiloRebrand
//
//  Created by csoler on 11/3/25.
//

public class XCConfigParser {
    
    public static func parse(from filePath: String) -> [XCConfigProperties: Any]? {
        guard let content = try? String(contentsOfFile: filePath) else {
            print("Error: No se pudo leer el archivo en \(filePath)")
            return nil
        }
        
        var config: [XCConfigProperties: String] = [:]
        
        let lines = content.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespaces) }
        for line in lines {
            guard !line.isEmpty, !line.hasPrefix("//") else {
                continue
            }
            
            let components = line.split(separator: "=", maxSplits: 1).map { $0.trimmingCharacters(in: .whitespaces) }
            if components.count == 2, let key = XCConfigProperties(rawValue: components[0]) {
                config[key] = components[1]
            }
        }
        
        return config
    }
    
}

public enum XCConfigProperties: String {
    case accessibilityDeclaration = "ACCESSIBILITY_DECLARATION"
    case activationBaseUrl = "ACTIVATION_BASE_URL"
    case adfs = "ADFS"
    case alwaysAvailableResourceEnabled = "ALWAYS_AVAILABLE_RESOURCE_ENABLED"
    case appColor = "APP_COLOR"
    case apiBaseUrl = "API_BASE_URL"
    case bezierPathColorTabbar = "BEZIER_PATH_COLOR_TABBAR"
    case bregal = "BREGAL"
    case bundleID = "PRODUCT_BUNDLE_IDENTIFIER"
    case bundleScheme = "BUNDLE_SCHEME"
    case bundleSchemeLogout = "BUNDLE_SCHEME_LOGOUT"
    case carouselNavigateArrowMaincolorEnabled = "CAROUSEL_NAVIGATE_ARROW_MAINCOLOR_ENABLED"
    case checkAccessToken = "CHECK_ACCESS_TOKEN"
    case checkRefreshAccessTokenEnabled = "CHECK_REFRESH_ACCESS_TOKEN_ENABLED"
    case clientCode = "CLIENT_CODE"
    case clientIdRegister = "CLIENTID_REGISTER"
    case clientIdRegisterFinal = "CLIENTID_REGISTER_FINAL"
    case clientAppIosEnabled = "CLIENT_APP_IOS_ENABLED"
    case customFontEnabled = "CUSTOM_FONT_ENABLED"
    case customKeySelectorLogin = "CUSTOM_KEY_SELECTOR_LOGIN"
    case customLogoutConfiguration = "CUSTOM_LOGOUT_CONFIGURATION"
    case customLogoutEnabled = "CUSTOM_LOGOUT_ENABLED"
    case customLogoutUrl = "CUSTOM_LOGOUT_URL"
    case customSelectorLogin = "CUSTOM_SELECTOR_LOGIN"
    case customTabbarEnabled = "CUSTOM_TABBAR_ENABLED"
    case darkMode = "DARK_MODE"
    case defaultStatusBarEnabled = "DEFAULT_STATUS_BAR_ENABLED"
    case deleteAccountAlertKey = "DELETE_ACCOUNT_ALERT_KEY"
    case deleteAccountUrl = "DELETE_ACCOUNT_URL"
    case deleteAccountUrlEnabled = "DELETE_ACCOUNT_URL_ENABLED"
    case developmentTeam = "DEVELOPMENT_TEAM"
    case dutchFormatDatesEnabled = "DUTCH_FORMAT_DATES_ENABLED"
    case dutchLanguageDefaultEnabled = "DUTCH_LANGUAGE_DEFAULT_ENABLED"
    case errorCodeFeature = "ERROR_CODE_FEATURE"
    case externalLogoutEnabled = "EXTERNAL_LOGOUT_ENABLED"
    case facebookAdvertiserEnabled = "FACEBOOK_ADVERTISER_ENABLED"
    case facebookAppId = "FACEBOOK_APP_ID"
    case facebookClientToken = "FACEBOOK_CLIENT_TOKEN"
    case facebookCodelessDebugEnabled = "FACEBOOK_CODELESS_DEBUG_ENABLED"
    case facebookLogEnabled = "FACEBOOK_LOG_ENABLED"
    case fakeStreaming = "FAKE_STREAMING"
    case fileSharing = "FILE_SHARING"
    case fullLogoutUrl = "FULL_LOGOUT_URL"
    case hasTeaser = "HAS_TEASER"
    case hideArabicHebrew = "HIDE_ARABIC_HEBREW"
    case hideAvailabilityInfo = "HIDE_AVAILABILITY_INFO"
    case hideBadges = "HIDE_BADGES"
    case hideCheckTermsPolicy = "HIDE_CHECK_TERMS_POLICY"
    case hideHolds = "HIDE_HOLDS"
    case hideLastLogin = "HIDE_LAST_LOGIN"
    case hideLogo = "HIDE_LOGO"
    case hideNovelties = "HIDE_NOVELTIES"
    case hidePayPerCheckout = "HIDE_PAY_PER_CHECKOUT"
    case hideRateApp = "HIDE_RATE_APP"
    case hideRecommendApp = "HIDE_RECOMMEND_APP"
    case hideReportProblem = "HIDE_REPORT_PROBLEM"
    case hideReturnLoan = "HIDE_RETURN_LOAN"
    case hideSearchbar = "HIDE_SEARCHBAR"
    case hideSearchFeature = "HIDE_SEARCH_FEATURE"
    case hideShareApp = "HIDE_SHARE_APP"
    case hideSuggestions = "HIDE_SUGGESTIONS"
    case higherShadowOffset = "HIGHER_SHADOW_OFFSET"
    case keyCipherTestEnabled = "KEY_CIPHER_TEST_ENABLED"
    case krsLoginErrorEnabled = "KRS_LOGIN_ERROR_ENABLED"
    case logoutQueryParamConfiguration = "LOGOUT_QUERY_PARAM_CONFIGURATION"
    case logoutScheme = "LOGOUT_SCHEME"
    case logoutTokenHintQueryParam = "LOGOUT_TOKEN_HINT_QUERY_PARAM"
    case mainColorTabbar = "MAIN_COLOR_TABBAR"
    case matomoId = "MATOMO_ID"
    case matomoUrl = "MATOMO_URL"
    case maxCheckoutsKeyEnabled = "MAX_CHECKOUTS_KEY_ENABLED"
    case migrationKbReaderSettings = "MIGRATION_KB_READER_SETTINGS"
    case moveCheckoutPreviewButtons = "MOVE_CHECKOUT_PREVIEW_BUTTONS"
    case navigationBarH6Enabled = "NAVIGATION_BAR_H6_ENABLED"
    case openDocumentsInPlace = "OPEN_DOCUMENTS_IN_PLACE"
    case partnerLibrariesUrl = "PARTNER_LIBRARIES_URL"
    case privacyUrl = "PRIVACY_URL"
    case redirectUri = "REDIRECT_URI"
    case redirectShelfOpenResource = "REDIRECT_SHELF_OPEN_RESOURCE"
    case registerScheme = "REGISTER_SCHEME"
    case registerSchemeEnabled = "REGISTER_SCHEME_ENABLED"
    case registerSchemeFinal = "REGISTER_SCHEME_FINAL"
    case replaceClientIdRegister = "REPLACE_CLIENTID_REGISTER"
    case resourceFormatWhiteBackground = "RESOURCE_FORMAT_WHITE_BACKGROUND"
    case resourceIdStreamEnabled = "RESOURCE_ID_STREAM_ENABLED"
    case resourceSizeProblem = "RESOURCE_SIZE_PROBLEM"
    case revokeTokens = "REVOKE_TOKENS"
    case setCas = "SET_CAS"
    case setVendorId = "SET_VENDOR_ID"
    case showDeleteAccountAlert = "SHOW_DELETE_ACCOUNT_ALERT"
    case showWrongCatalogAlert = "SHOW_WRONG_CATALOG_ALERT"
    case skipInfoEndpoint = "SKIP_INFO_ENDPOINT"
    case specialPdfKb = "SPECIAL_PDF_KB"
    case teaserUrl = "TEASER_URL"
    case termsUrl = "TERMS_URL"
    case tintColorTabbar = "TINT_COLOR_TABBAR"
    case validatePostalCode = "VALIDATE_POSTAL_CODE"
}
