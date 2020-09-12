/*
 * Static Apex access layer for Queue object
 * 
 * @author Pavel Drozd
 * @since 09-12-2020
 */
public with sharing class QueueSelector {

    private static final String QUEUE = 'Queue';
    
    public static Group getQueueByName(String name) {
        Group queue = [SELECT Id FROM Group WHERE Type = :QUEUE AND Name = :name];
        return queue;
    }

    public static Set<Id> getQueueMemberIds(String name) {
        Id queueId = getQueueByName(name).Id;
        List<GroupMember> members = [SELECT UserOrGroupId FROM GroupMember where GroupId = :queueId];
        Set<Id> result = new Set<Id>();
        for (GroupMember member: members) {
            result.add(member.UserOrGroupId);
        }
        return result;
    }

}
