package f1.m2.config

import org.springframework.context.annotation.Configuration
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer

@Configuration
class WebConfig : WebMvcConfigurer {

    //    map thư mục /WEB-INT/resource qua ResourceHandler để trình duyệt có thể tải:
    override fun addResourceHandlers(registry: ResourceHandlerRegistry) {
        // css
        registry.addResourceHandler("/css/**").addResourceLocations("/WEB-INF/resources/css/")
        // js
        registry.addResourceHandler("/js/**").addResourceLocations("/WEB-INF/resources/js/")
        // image
        registry.addResourceHandler("/image/**").addResourceLocations("/WEB-INF/resources/image/")
    }
}