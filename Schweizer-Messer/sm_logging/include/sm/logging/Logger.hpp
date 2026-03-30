#ifndef SM_LOGGER_HPP
#define SM_LOGGER_HPP

#include <string>
#include <chrono>
#include <spdlog/spdlog.h>
#include <spdlog/sinks/stdout_color_sinks.h>
#include <memory>

namespace sm {
    namespace logging {

        struct LoggingEvent;

        class Logger
        {
        public:
            typedef std::chrono::system_clock Clock;
            typedef Clock::time_point Time;
            typedef Clock::duration Duration;


            Logger();
            virtual ~Logger();

            double currentTimeSecondsUtc() const;
            std::string currentTimeString() const;
            Time currentTime() const;

            void log(const LoggingEvent & event);
        protected:
            virtual Time currentTimeImplementation() const;
            virtual void logImplementation(const LoggingEvent & event) = 0;
        };

        // 全局日志器
        void initializeLogging(const std::string& loggerName = "kalibr");
        std::shared_ptr<spdlog::logger>& getSpdLogger();

    } // namespace logging
} // namespace sm


#endif /* SM_LOGGER_HPP */
