<?xml version="1.0" encoding="UTF-8"?>
<SyncSourceSystemJournalEntry xmlns="http://schema.infor.com/InforOAGIS/2" languageCode="en-US" releaseID="9.2" systemEnvironmentCode="Production" versionID="2.8.0">
    <ApplicationArea>
        <Sender>
            <LogicalID>lid://infor.eam.eam</LogicalID>
            <ComponentID>EAM</ComponentID>
            <TaskID>Accounting</TaskID>
            <ConfirmationCode>OnError</ConfirmationCode>
        </Sender>
        <CreationDateTime>2022-05-26T14:00:07Z</CreationDateTime>
        <BODID>infor-nid:infor:::WORETNTOSTORE:VDP:253939:1?SourceSystemJournalEntry&amp;verb=Sync&amp;event=1653573604060</BODID>
    </Applicat
                <ActionExpression actionCode="Add"/>
            </ActionCriteria>
            <AccountingEntityID>DTS</AccountingEntityID>
        </Sync>
        <SourceSystemJournalEntry>
            <JournalEntryHeader>
                <JournalID accountingEntity="DTS" lid="lid://infor.eam.eam" variationID="1653573604060">WORETNTOSTORE:VDP:253939</JournalID>
                <BaseJournalEntryHeader>
                    <LedgerID>1</LedgerID>
                    <DocumentDateTime>2022-05-26T14:00:07Z</DocumentDateTime>
                    <AccountingDate>
                        <PostDateTime>2022-05-26T05:14:00Z</PostDateTime>
                    </AccountingDate>
                    <SourceDocumentReference type="JournalEntrySource">
                        <DocumentDateTime>2022-05-26T05:14:00Z</DocumentDateTime>
                        <Description>INFOREAM</Description>
                    </SourceDocumentReference>
                    <Amount currencyID="AUD">17.510000</Amount>
                    <Description>WORETNTOSTORE:VDP:134781:132938</Description>
                    <UserArea>
                        <Property>
                            <NameValue name="eam.DocType" type="StringType">WORETNTOSTORE:VDP</NameValue>
                        </Property>
                        <Property>
                            <NameValue name="eam.GLEntitys" type="StringType">-</NameValue>
                        </Property>
                    </UserArea>
                    <LedgerType>Actual</LedgerType>
                    <TransactionReferenceText>WORETNTOSTORE:VDP:134781:132938</TransactionReferenceText>
                    <EnteredAudit>
                        <PersonReference>
                            <IDs>
                                <ID>42</ID>
                            </IDs>
                        </PersonReference>
                    </EnteredAudit>
                    <LedgerID/>
                    <AccountingJournalReference>
                        <ID/>
                    </AccountingJournalReference>
                </BaseJournalEntryHeader>
            </JournalEntryHeader>
            <JournalEntryLine>
                <AccountingChartReference>
                    <ID>DTS</ID>
                </AccountingChartReference>
                <Amount currencyID="AUD">17.510000</Amount>
                <GLAccount>
                    <GLNominalAccount>0111</GLNominalAccount>
                </GLAccount>
                <DimensionCodes>
                    <DimensionCode sequence="1" listID="COST CENTRE">0111</DimensionCode>
                    <DimensionCode sequence="2" listID="OPERATING SYSTM"/>
                </DimensionCodes>
                <UserArea>
                    <Property>
                        <NameValue name="eam.JECategoryName" type="StringType">OTHERS</NameValue>
                    </Property>
                    <Property>
                        <NameValue name="eam.BudgetVersionID" type="NumericType">134781</NameValue>
                    </Property>
                    <Property>
                        <NameValue name="eam.GLReference1" type="StringType">10995953</NameValue>
                    </Property>
                    <Property>
                        <NameValue name="eam.GLReference2" type="StringType">10003</NameValue>
                    </Property>
                    <Property>
                        <NameValue name="eam.GLReference3" type="StringType">RETURN</NameValue>
                    </Property>
                    <Property>
                        <NameValue name="eam.GLStatus" type="StringType">NEW</NameValue>
                    </Property>
                    <Property>
                        <NameValue name="eam.GroupID" type="StringType">VDP</NameValue>
                    </Property>
                </UserArea>
                <DebitCreditFlag>DEBIT</DebitCreditFlag>
                <Description/>
                <TransactionReferenceText/>
                <ExchangeRateDateTime/>
                <FunctionalAmount/>
                <SourceAccountingDate>
                    <PeriodID/>
                </SourceAccountingDate>
            </JournalEntryLine>
            <JournalEntryLine>
                <AccountingChartReference>
                    <ID>DTS</ID>
                </AccountingChartReference>
                <Amount currencyID="AUD">17.510000</Amount>
                <GLAccount>
                    <GLNominalAccount>8615PRO00</GLNominalAccount>
                </GLAccount>
                <DimensionCodes>
                    <DimensionCode sequence="1" listID="COST CENTRE">8615</DimensionCode>
                    <DimensionCode sequence="2" listID="OPERATING SYSTM">PRO</DimensionCode>
                </DimensionCodes>
                <UserArea>
                    <Property>
                        <NameValue name="eam.JECategoryName" type="StringType">OTHERS</NameValue>
                    </Property>
                    <Property>
                        <NameValue name="eam.BudgetVersionID" type="NumericType">134781</NameValue>
                    </Property>
                    <Property>
                        <NameValue name="eam.GLReference1" type="StringType">10995953</NameValue>
                    </Property>
                    <Property>
                        <NameValue name="eam.GLReference2" type="StringType">10003</NameValue>
                    </Property>
                    <Property>
                        <NameValue name="eam.GLReference3" type="StringType">RETURN</NameValue>
                    </Property>
                    <Property>
                        <NameValue name="eam.GLStatus" type="StringType">NEW</NameValue>
                    </Property>
                    <Property>
                        <NameValue name="eam.GroupID" type="StringType">VDP</NameValue>
                    </Property>
                </UserArea>
                <DebitCreditFlag>CREDIT</DebitCreditFlag>
                <Description/>
                <TransactionReferenceText/>
                <ExchangeRateDateTime/>
                <FunctionalAmount/>
                <SourceAccountingDate>
                    <PeriodID/>
                </SourceAccountingDate>
            </JournalEntryLine>
        </SourceSystemJournalEntry>
    </DataArea>
</SyncSourceSystemJournalEntry>