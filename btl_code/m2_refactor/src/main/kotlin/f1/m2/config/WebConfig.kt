package f1.m2.config

import f1.m2.authentication.StaffAuthInterceptor
import org.springframework.context.annotation.Configuration
import org.springframework.web.servlet.config.annotation.InterceptorRegistry
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer

@Configuration
class WebConfig(
    private val staffAuth: StaffAuthInterceptor
) : WebMvcConfigurer {

    //    cho phep truy cap qua resource handler
    override fun addResourceHandlers(registry: ResourceHandlerRegistry) {
        // css
        registry.addResourceHandler("/css/**").addResourceLocations("/WEB-INF/resources/css/")
        // js
        registry.addResourceHandler("/js/**").addResourceLocations("/WEB-INF/resources/js/")
        // image
        registry.addResourceHandler("/image/**").addResourceLocations("/WEB-INF/resources/image/")
    }

    // auth
//    override fun addInterceptors(registry: InterceptorRegistry) {
//        registry.addInterceptor(staffAuth)
//            .addPathPatterns("/race", "/results/**/update/**", "/results/**/review/**", "/results/**/save/**")
//    }
}