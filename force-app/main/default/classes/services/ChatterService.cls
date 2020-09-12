/*
 * Apex service for Chatter-related operations
 * 
 * @author Pavel Drozd
 * @since 09-11-2020
 */
public with sharing class ChatterService {
    
    @testVisible
    private List<ConnectApi.BatchInput> inputs;

    public ChatterService() {
        inputs = new List<ConnectApi.BatchInput>();
    }

    public void addPost(Set<Id> recipients, String message, Id subjectId) {
        if (recipients == null) {
            throw new CustomException('Wrong recipients.');
        }
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
        messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
        messageBodyInput.messageSegments.addAll(this.getMentions(recipients));
        ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
        textSegmentInput.text = message;
        messageBodyInput.messageSegments.add(textSegmentInput);
        feedItemInput.body = messageBodyInput;
        feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
        feedItemInput.subjectId = subjectId;
        ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(feedItemInput);
        this.inputs.add(batchInput);
    }

    public void send() {
        List<ConnectApi.BatchResult> results = ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), this.inputs);
        for (ConnectApi.BatchResult batchResult : results) {
            if (!batchResult.isSuccess()) {
                throw new CustomException(batchResult.getErrorMessage());
            }
        }
    }

    private List<ConnectApi.MentionSegmentInput> getMentions(Set<Id> recipients) {
        List<ConnectApi.MentionSegmentInput> mentions = new List<ConnectApi.MentionSegmentInput>();
        for (Id userId : recipients) {
            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            mentionSegmentInput.Id = userId;
            mentions.add(mentionSegmentInput);
        }
        return mentions;
    }
}
