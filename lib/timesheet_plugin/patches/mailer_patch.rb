module TimesheetPlugin
  module Patches
    module MailerPatch
      def self.included(base)
        base.extend(ClassMethods)

        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable
        end
      end

      module ClassMethods
      end

      module InstanceMethods
        # Submitting a new timesheet
        def timesheet_submitted(manager, user, start_date, url)
          recipients [manager.mail]
          subject l(:mail_subject_timesheet_submitted, user.name)
          body :user => user,
               :url => url,
               :start_date => start_date
          render_multipart('timesheet_submitted', body)
        end

        # Builds a tmail object used to email the HR of an approved timesheet.
        #
        def timesheet_approved(manager, user, start_date, url)
          recipients Timesheet.config['hr_email']
          subject l(:mail_subject_timesheet_approved, :manager => manager.name,
                    :user => user.name)
          body :manager => manager.name,
               :user => user.name,
               :url => url,
               :start_date => start_date
          render_multipart('timesheet_approved', body)
        end
      end   
    end
  end
end



 

